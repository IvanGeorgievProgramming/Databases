from sqlalchemy import create_engine, text
from sqlalchemy import Column, Integer, String, ForeignKey, Row
from sqlalchemy.orm import sessionmaker, declarative_base, relationship
import os

BASE_DIR = os.path.dirname(os.path.realpath(__file__))
connection_string = 'sqlite:///' + os.path.join(BASE_DIR, 'blog.db')
engine = create_engine(connection_string)

Base = declarative_base()

"""
Class Company:
    company_id int primary key
    company_name string
    company_address string
    company_founded_date date

class Employee:
    employee_id int primary key
    employee_name string
    eployee_speciality string
    company_id foreign key

class Project:
    project_id int primary key
    project_name string
    project_description string
    employee_id foreign key
"""

class Company(Base):
    __tablename__ = 'companies'
    company_id = Column(Integer, primary_key=True)
    company_name = Column(String(40), nullable=False)
    company_address = Column(String(80), nullable=True)
    company_founded_date = Column(String(80), nullable=True)

    employees = relationship('Employee', back_populates = 'company', cascade = 'all, delete')

    def __repr__(self):
        return f'Company(company_id = {self.company_id}, company_name = {self.company_name}, company_address = {self.company_address}, company_founded_date = {self.company_founded_date})'
    
class Employee(Base):
    __tablename__ = 'employees'
    employee_id = Column(Integer, primary_key=True)
    employee_name = Column(String(40), nullable=False)
    employee_speciality = Column(String(80), nullable=True)
    company_id = Column(Integer(), ForeignKey('companies.company_id'))

    company = relationship('Company', back_populates = 'employees')
    projects = relationship('Project', back_populates = 'employee', cascade = 'all, delete')

    def __repr__(self):
        return f'Employee(employee_id = {self.employee_id}, employee_name = {self.employee_name}, employee_speciality = {self.employee_speciality}, company_id = {self.company_id})'

class Project(Base):
    __tablename__ = 'projects'
    project_id = Column(Integer, primary_key=True)
    project_name = Column(String(40), nullable=False)
    project_description = Column(String(80), nullable=True)
    employee_id = Column(Integer(), ForeignKey('employees.employee_id'))

    employee = relationship('Employee', back_populates = 'projects')

    def __repr__(self):
        return f'Project(project_id = {self.project_id}, project_name = {self.project_name}, project_description = {self.project_description}, employee_id = {self.employee_id})'

Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()

# Add companies from user input until user enters 'quit'
while True:
    company_name = input('Enter company name: ')
    if company_name == 'quit':
        break
    company_address = input('Enter company address: ')
    company_founded_date = input('Enter company founded date: ')
    company = Company(company_name = company_name, company_address = company_address, company_founded_date = company_founded_date)
    session.add(company)
    session.commit()
print()

# Add employees from user input until user enters 'quit'
while True:
    employee_name = input('Enter employee name: ')
    if employee_name == 'quit':
        break
    employee_speciality = input('Enter employee speciality: ')
    company_name = input('Enter company name: ')
    company_id = session.query(Company.company_id).filter(Company.company_name == company_name).first()[0]
    # Access the actual value from the row object using indexing [0]
    employee = Employee(employee_name=employee_name, employee_speciality=employee_speciality, company_id=company_id)
    session.add(employee)
    session.commit()

print()

# Add projects from user input until user enters 'quit'
while True:
    project_name = input('Enter project name: ')
    if project_name == 'quit':
        break
    project_description = input('Enter project description: ')
    employee_name = input('Enter employee name: ')
    employee_id = session.query(Employee.employee_id).filter(Employee.employee_name == employee_name).first()[0]
    # Access the actual value from the row object using indexing [0]
    project = Project(project_name=project_name, project_description=project_description, employee_id=employee_id)
    session.add(project)
    session.commit()

print()

with engine.connect() as connection:
    # Create a temporary 'tasks' table
    connection.execute(text("""
    CREATE TEMPORARY TABLE tasks (
        id INTEGER PRIMARY KEY,
        task_name TEXT NOT NULL,
        employee_id INTEGER,
        date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(employee_id) REFERENCES employees(id)
    )
    """))

    # Insert data into the temporary table
    while True:
        task_name = input('Enter task name: ')
        if task_name == 'quit':
            break
        employee_name = input('Enter employee name: ')
        employee_id = session.query(Employee.employee_id).filter(Employee.employee_name == employee_name).first()[0]
        connection.execute(text("""
        INSERT INTO tasks (task_name, employee_id) VALUES (:task_name, :employee_id)
        """), {'task_name': task_name, 'employee_id': employee_id})
        print(f"Task '{task_name}' added to employee '{employee_name}'")

    connection.execute(text("""
    CREATE TEMPORARY TABLE task_history AS
    SELECT tasks.task_name, employees.employee_name, tasks.date_created
    FROM tasks
    JOIN employees ON tasks.employee_id = employees.employee_id
    """))

    result = connection.execute(text("""
    SELECT * FROM task_history
    """))
    for row in result:
        print(row)