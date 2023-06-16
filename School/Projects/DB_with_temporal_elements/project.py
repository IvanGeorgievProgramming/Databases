from sqlalchemy import create_engine, text
from sqlalchemy import Column, Integer, String, ForeignKey, Row
from sqlalchemy.orm import sessionmaker, declarative_base, relationship
from datetime import datetime
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

Class Company_History:
    company_history_id int primary key
    event_date datetime
    event_type char(1)
    company_id foreign key
    company_name string
    company_address string
    company_founded_date date

Class Employee_History:
    employee_history_id int primary key
    event_date datetime
    event_type char(1)
    employee_id foreign key
    employee_name string
    employee_speciality string
    company_id foreign key

Class Project_History:
    project_history_id int primary key
    event_date datetime
    event_type char(1)
    project_id foreign key
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
        return f'Company (company_name = {self.company_name}, company_address = {self.company_address}, company_founded_date = {self.company_founded_date})'

class Employee(Base):
    __tablename__ = 'employees'
    employee_id = Column(Integer, primary_key=True)
    employee_name = Column(String(40), nullable=False)
    employee_speciality = Column(String(80), nullable=True)
    company_id = Column(Integer(), ForeignKey('companies.company_id'))

    company = relationship('Company', back_populates = 'employees')
    projects = relationship('Project', back_populates = 'employee', cascade = 'all, delete')

    def __repr__(self):
        employee_company_name = self.company.company_name if self.company else None
        return f'Employee (employee_name = {self.employee_name}, employee_speciality = {self.employee_speciality}, company_name = {employee_company_name})'

class Project(Base):
    __tablename__ = 'projects'
    project_id = Column(Integer, primary_key=True)
    project_name = Column(String(40), nullable=False)
    project_description = Column(String(80), nullable=True)
    employee_id = Column(Integer(), ForeignKey('employees.employee_id'))

    employee = relationship('Employee', back_populates = 'projects')

    def __repr__(self):
        project_employee_name = self.employee.employee_name if self.employee else None
        return f'Project (project_name = {self.project_name}, project_description = {self.project_description}, employee_name = {project_employee_name})'

class Company_History(Base):
    __tablename__ = 'companies_history'
    company_history_id = Column(Integer, primary_key=True)
    event_date = Column(String(100), nullable=False)
    event_type = Column(String(1), nullable=False)
    company_id = Column(Integer(), ForeignKey('companies.company_id'))
    company_name = Column(String(40), nullable=False)
    company_address = Column(String(80), nullable=True)
    company_founded_date = Column(String(80), nullable=True)

    def __repr__(self):
        return f'Company_History (event_date = {self.event_date}, event_type = {self.event_type}, company_name = {self.company_name}, company_address = {self.company_address}, company_founded_date = {self.company_founded_date})'

class Employee_History(Base):
    __tablename__ = 'employees_history'
    employee_history_id = Column(Integer, primary_key=True)
    event_date = Column(String(100), nullable=False)
    event_type = Column(String(1), nullable=False)
    employee_id = Column(Integer(), ForeignKey('employees.employee_id'))
    employee_name = Column(String(40), nullable=False)
    employee_speciality = Column(String(80), nullable=True)
    company_id = Column(Integer(), ForeignKey('companies.company_id'))

    def __repr__(self):
        company = session.query(Company).filter(Company.company_id == self.company_id).first()
        h_employee_company_name = company.company_name if company else None
        return f'Employee_History (event_date = {self.event_date}, event_type = {self.event_type}, employee_name = {self.employee_name}, employee_speciality = {self.employee_speciality}, company_name = {h_employee_company_name})'

class Project_History(Base):
    __tablename__ = 'projects_history'
    project_history_id = Column(Integer, primary_key=True)
    event_date = Column(String(100), nullable=False)
    event_type = Column(String(1), nullable=False)
    project_id = Column(Integer(), ForeignKey('projects.project_id'))
    project_name = Column(String(40), nullable=False)
    project_description = Column(String(80), nullable=True)
    employee_id = Column(Integer(), ForeignKey('employees.employee_id'))

    def __repr__(self):
        employee = session.query(Employee).filter(Employee.employee_id == self.employee_id).first()
        h_project_employee_name = employee.employee_name if employee else None
        return f'Project_History (event_date = {self.event_date}, event_type = {self.event_type}, project_name = {self.project_name}, project_description = {self.project_description}, employee_name = {h_project_employee_name})'

Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()

with engine.connect() as connection:
    connection.execute(text("DROP TRIGGER IF EXISTS company_history_insert"))
    connection.execute(text(f"""
    CREATE TRIGGER company_history_insert AFTER INSERT ON companies FOR EACH ROW
    BEGIN
        INSERT INTO companies_history(event_date, event_type, company_id, company_name, company_address, company_founded_date)
        VALUES ('{datetime.now()}', 'I', NEW.company_id, NEW.company_name, NEW.company_address, NEW.company_founded_date);
    END
    """))

    connection.execute(text("DROP TRIGGER IF EXISTS company_history_update"))
    connection.execute(text(f"""
    CREATE TRIGGER company_history_update AFTER UPDATE ON companies FOR EACH ROW
    BEGIN
        INSERT INTO companies_history(event_date, event_type, company_id, company_name, company_address, company_founded_date)
        VALUES ('{datetime.now()}', 'U', NEW.company_id, NEW.company_name, NEW.company_address, NEW.company_founded_date);
    END
    """))

    connection.execute(text("DROP TRIGGER IF EXISTS company_history_delete"))
    connection.execute(text(f"""
    CREATE TRIGGER company_history_delete AFTER DELETE ON companies FOR EACH ROW
    BEGIN
        INSERT INTO companies_history(event_date, event_type, company_id, company_name, company_address, company_founded_date)
        VALUES ('{datetime.now()}', 'D', OLD.company_id, OLD.company_name, OLD.company_address, OLD.company_founded_date);
    END
    """))

    connection.execute(text("DROP TRIGGER IF EXISTS employee_history_insert"))
    connection.execute(text(f"""
    CREATE TRIGGER employee_history_insert AFTER INSERT ON employees FOR EACH ROW
    BEGIN
        INSERT INTO employees_history(event_date, event_type, employee_id, employee_name, employee_speciality, company_id)
        VALUES ('{datetime.now()}', 'I', NEW.employee_id, NEW.employee_name, NEW.employee_speciality, NEW.company_id);
    END
    """))

    connection.execute(text("DROP TRIGGER IF EXISTS employee_history_update"))
    connection.execute(text(f"""
    CREATE TRIGGER employee_history_update AFTER UPDATE ON employees FOR EACH ROW
    BEGIN
        INSERT INTO employees_history(event_date, event_type, employee_id, employee_name, employee_speciality, company_id)
        VALUES ('{datetime.now()}', 'U', NEW.employee_id, NEW.employee_name, NEW.employee_speciality, NEW.company_id);
    END
    """))

    connection.execute(text("DROP TRIGGER IF EXISTS employee_history_delete"))
    connection.execute(text(f"""
    CREATE TRIGGER employee_history_delete AFTER DELETE ON employees FOR EACH ROW
    BEGIN
        INSERT INTO employees_history(event_date, event_type, employee_id, employee_name, employee_speciality, company_id)
        VALUES ('{datetime.now()}', 'D', OLD.employee_id, OLD.employee_name, OLD.employee_speciality, OLD.company_id);
    END
    """))

    connection.execute(text("DROP TRIGGER IF EXISTS project_history_insert"))
    connection.execute(text(f"""
    CREATE TRIGGER project_history_insert AFTER INSERT ON projects FOR EACH ROW
    BEGIN
        INSERT INTO projects_history(event_date, event_type, project_id, project_name, project_description, employee_id)
        VALUES ('{datetime.now()}', 'I', NEW.project_id, NEW.project_name, NEW.project_description, NEW.employee_id);
    END
    """))

    connection.execute(text("DROP TRIGGER IF EXISTS project_history_update"))
    connection.execute(text(f"""
    CREATE TRIGGER project_history_update AFTER UPDATE ON projects FOR EACH ROW
    BEGIN
        INSERT INTO projects_history(event_date, event_type, project_id, project_name, project_description, employee_id)
        VALUES ('{datetime.now()}', 'U', NEW.project_id, NEW.project_name, NEW.project_description, NEW.employee_id);
    END
    """))

    connection.execute(text("DROP TRIGGER IF EXISTS project_history_delete"))
    connection.execute(text(f"""
    CREATE TRIGGER project_history_delete AFTER DELETE ON projects FOR EACH ROW
    BEGIN
        INSERT INTO projects_history(event_date, event_type, project_id, project_name, project_description, employee_id)
        VALUES ('{datetime.now()}', 'D', OLD.project_id, OLD.project_name, OLD.project_description, OLD.employee_id);
    END
    """))

    """
    Function that gets an input from the user and make him do the input again the input contains one of the following:
    ' 
    " 
    ; 
    -- 
    /* */ 
    OR 
    AND 
    % 
    _
    """
    def input_check(user_input):
        while True:
            if "'" in user_input or '"' in user_input or ';' in user_input or '--' in user_input or '/*' in user_input or '*/' in user_input or 'OR' in user_input or 'AND' in user_input or '%' in user_input or '_' in user_input:
                print(f'Invalid input! The input must not contain one of the following: \'" ; -- /* */ OR AND % _')
                user_input = input('Enter again: ')
            else:
                break
        return user_input
    
    """
    Make a function that creates a company to the database
    """
    def create_company():
        company_name = input_check(input('Enter company name: '))
        company_address = input_check(input('Enter company address: '))
        company_founded_date = input_check(input('Enter company founded date: '))

        company = Company(company_name = company_name, company_address = company_address, company_founded_date = company_founded_date)
        session.add(company)
        session.commit()
    """
    Make a function that creates an employee to the database
    """
    def create_employee():
        # Check if there are any companies in the database
        if session.query(Company).first() == None:
            print('There are no companies in the database!')
            return

        employee_name = input_check(input('Enter employee name: '))
        employee_speciality = input_check(input('Enter employee speciality: '))
        # Check if the company id exists in the database
        while True:
            company_name = input_check(input('Enter company name: '))
            company = session.query(Company).filter(Company.company_name == company_name).first()
            if company == None:
                print('The company name does not exist in the database!')
            else:
                break
        employee = Employee(employee_name = employee_name, employee_speciality = employee_speciality, company_id = company.company_id)
        session.add(employee)
        session.commit()
    """
    Make a function that creates a project to the database
    """
    def create_project():
        # Check if there are any companies in the database
        if session.query(Company).first() == None:
            print('There are no companies in the database!')
            return
        # Check if there are any employees in the database
        if session.query(Employee).first() == None:
            print('There are no employees in the database!')
            return
        
        project_name = input_check(input('Enter project name: '))
        project_description = input_check(input('Enter project description: '))
        # Check if the employee id exists in the database
        while True:
            employee_name = input_check(input('Enter employee name: '))
            employee = session.query(Employee).filter(Employee.employee_name == employee_name).first()
            if employee == None:
                print('The employee name does not exist in the database!')
            else:
                break
        project = Project(project_name = project_name, project_description = project_description, employee_id = employee.employee_id)
        session.add(project)
        session.commit()
    """
    Make a function that updates a company in the database
    """
    def update_company():
        # Check if there are any companies in the database
        if session.query(Company).first() == None:
            print('There are no companies in the database!')
            return

        # Check if the company id exists in the database
        while True:
            company_name = input_check(input('Enter company name: '))
            company = session.query(Company).filter(Company.company_name == company_name).first()
            if company == None:
                print('The company name does not exist in the database!')
            else:
                break
        
        company_name = input_check(input('Enter new company name: '))
        company_address = input_check(input('Enter new company address: '))
        company_founded_date = input_check(input('Enter new company founded date: '))

        company.company_name = company_name
        company.company_address = company_address
        company.company_founded_date = company_founded_date
        session.commit()
    """
    Make a function that updates an employee in the database
    """
    def update_employee():
        # Check if there are any employees in the database
        if session.query(Employee).first() == None:
            print('There are no employees in the database!')
            return

        # Check if the employee id exists in the database
        while True:
            employee_name = input_check(input('Enter employee name: '))
            employee = session.query(Employee).filter(Employee.employee_name == employee_name).first()
            if employee == None:
                print('The employee name does not exist in the database!')
            else:
                break
        
        # Check if the company id exists in the database
        while True:
            company_name = input_check(input('Enter company name: '))
            company = session.query(Company).filter(Company.company_name == company_name).first()
            if company == None:
                print('The company name does not exist in the database!')
            else:
                break

        employee_name = input_check(input('Enter new employee name: '))
        employee_speciality = input_check(input('Enter new employee speciality: '))

        employee.employee_name = employee_name
        employee.employee_speciality = employee_speciality
        employee.company_id = company.company_id
        session.commit()
    """
    Make a function that updates a project in the database
    """
    def update_project():
        # Check if there are any projects in the database
        if session.query(Project).first() == None:
            print('There are no projects in the database!')
            return

        # Check if the project id exists in the database
        while True:
            project_name = input_check(input('Enter project name: '))
            project = session.query(Project).filter(Project.project_name == project_name).first()
            if project == None:
                print('The project name does not exist in the database!')
            else:
                break
        
        # Check if the employee id exists in the database
        while True:
            employee_name = input_check(input('Enter employee name: '))
            employee = session.query(Employee).filter(Employee.employee_name == employee_name).first()
            if employee == None:
                print('The employee name does not exist in the database!')
            else:
                break
        
        project_name = input_check(input('Enter new project name: '))
        project_description = input_check(input('Enter new project description: '))

        project.project_name = project_name
        project.project_description = project_description
        project.employee_id = employee.employee_id
        session.commit()
    """
    Make a function that deletes a company from the database
    """
    def delete_company():
        # Check if there are any companies in the database
        if session.query(Company).first() == None:
            print('There are no companies in the database!')
            return

        # Check if the company id exists in the database
        while True:
            company_name = input_check(input('Enter company name: '))
            company = session.query(Company).filter(Company.company_name == company_name).first()
            if company == None:
                print('The company name does not exist in the database!')
            else:
                break

        session.delete(company)
        session.commit()
    """
    Make a function that deletes an employee from the database
    """
    def delete_employee():
        # Check if there are any employees in the database
        if session.query(Employee).first() == None:
            print('There are no employees in the database!')
            return

        # Check if the employee id exists in the database
        while True:
            employee_name = input_check(input('Enter employee name: '))
            employee = session.query(Employee).filter(Employee.employee_name == employee_name).first()
            if employee == None:
                print('The employee name does not exist in the database!')
            else:
                break

        session.delete(employee)
        session.commit()
    """
    Make a function that deletes a project from the database
    """
    def delete_project():
        # Check if there are any projects in the database
        if session.query(Project).first() == None:
            print('There are no projects in the database!')
            return

        # Check if the project id exists in the database
        while True:
            project_name = input_check(input('Enter project name: '))
            project = session.query(Project).filter(Project.project_name == project_name).first()
            if project == None:
                print('The project name does not exist in the database!')
            else:
                break

        session.delete(project)
        session.commit()
    """
    Make a function that prints all companies from the database
    """
    def print_companies():
        # Check if there are any companies in the database
        if session.query(Company).first() == None:
            print('There are no companies in the database!')
            return

        companies = session.query(Company).all()
        for company in companies:
            print(company)
    """
    Make a function that prints all employees from the database
    """
    def print_employees():
        # Check if there are any employees in the database
        if session.query(Employee).first() == None:
            print('There are no employees in the database!')
            return

        employees = session.query(Employee).all()
        for employee in employees:
            print(employee)
    """
    Make a function that prints all projects from the database
    """
    def print_projects():
        # Check if there are any projects in the database
        if session.query(Project).first() == None:
            print('There are no projects in the database!')
            return

        projects = session.query(Project).all()
        for project in projects:
            print(project)

    """
    Make a function that prints the company history from the companies history table
    """
    def print_companies_history():
        if session.query(Company_History).first() == None:
            print('There are no history of companies in the database!')
            return
        
        companies_history = session.query(Company_History).all()
        for company_history in companies_history:
            print(company_history)

    """
    Make a function that prints the employee history from the employees history table
    """
    def print_employees_history():
        if session.query(Employee_History).first() == None:
            print('There are no history of employees in the database!')
            return
        
        employees_history = session.query(Employee_History).all()
        for employee_history in employees_history:
            print(employee_history)

    """
    Make a function that prints the project history from the projects history table
    """
    def print_projects_history():
        if session.query(Project_History).first() == None:
            print('There are no history of projects in the database!')
            return
        
        projects_history = session.query(Project_History).all()
        for project_history in projects_history:
            print(project_history)

    """
    Make a function that prints the menu
    """
    def print_menu():
        print()
        print('Choose one of the following options:')
        print('1. Add company')
        print('2. Add employee')
        print('3. Add project')
        print('4. Update company')
        print('5. Update employee')
        print('6. Update project')
        print('7. Delete company')
        print('8. Delete employee')
        print('9. Delete project')
        print('10. Print companies')
        print('11. Print employees')
        print('12. Print projects')
        print('13. Print companies history')
        print('14. Print employees history')
        print('15. Print projects history')
        print('16. Exit')

    is_running = True
    while is_running:
        print_menu()
        choice = input_check(input('Enter your choice: '))
        if choice == '1':
            create_company()
        elif choice == '2':
            create_employee()
        elif choice == '3':
            create_project()
        elif choice == '4':
            update_company()
        elif choice == '5':
            update_employee()
        elif choice == '6':
            update_project()
        elif choice == '7':
            delete_company()
        elif choice == '8':
            delete_employee()
        elif choice == '9':
            delete_project()
        elif choice == '10':
            print_companies()
        elif choice == '11':
            print_employees()
        elif choice == '12':
            print_projects()
        elif choice == '13':
            print_companies_history()
        elif choice == '14':
            print_employees_history()
        elif choice == '15':
            print_projects_history()
        elif choice == '16':
            is_running = False
        else:
            print('Invalid choice!')