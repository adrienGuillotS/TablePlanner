import random
from classes import Family, Person
from utils import format_tables
from people import people


def can_seat(person, table):
    if not table:
        return True
    last_person = table[-1]
    if person.gender == last_person.gender:
        print("Cannot seta because: gender")
        print("Person:", person.name)   
        print("Last Person:", last_person.name)
        return False
    if person.family == last_person.family:
        print("Cannot seta because: family")
        print("Person:", person.name)
        print("Last Person:", last_person.name)
        return False
    return True


def generate_table_plan(attendees, table_sizes):
    """
    Generates table plans for the given attendees based on specified table sizes.
    """
    random.shuffle(attendees)

    table1, table2 = [], []
    table1_size, table2_size = table_sizes

    seated = set()  # Track seated people to prevent duplicates

    # Fill Table 1 completely before starting Table 2
    for person in attendees:
        print("Current Person:", person.name)
        if len(table1) < table1_size:
            if person not in seated and can_seat(person, table1):
                print("can seat")
                table1.append(person)
                seated.add(person)
            else:
                # Try the next person if the current one cannot seat
                for next_person in attendees[attendees.index(person) + 1 :]:
                    print("Next Person:", next_person.name)
                    if next_person not in seated and can_seat(next_person, table1):
                        print("next person can seat")
                        table1.append(next_person)
                        seated.add(next_person)
                        break
                else:
                    # If no suitable person is found, force seat the current person
                    if person not in seated:
                        table1.append(person)
                        seated.add(person)
                        print("FORCED SEAT")
            print("Current Table 1:", [p.name for p in table1])
            print("Current Table 2:", [p.name for p in table2])
            print("Seated Attendees:", {p.name for p in seated})
            print("-" * 50)
        elif len(table2) < table2_size:
            print("Table 1 is full")
            if person not in seated and can_seat(person, table2):
                table2.append(person)
                seated.add(person)
            else:
                # Try the next person if the current one cannot seat
                for next_person in attendees[attendees.index(person) + 1 :]:
                    if next_person not in seated and can_seat(next_person, table2):
                        table2.append(next_person)
                        seated.add(next_person)
                        break
                else:
                    # If no suitable person is found, force seat the current person
                    if person not in seated:
                        table2.append(person)
                        seated.add(person)

    # Force-seat any remaining attendees
    for person in attendees:
        if person not in seated:
            if len(table1) < table1_size:
                table1.append(person)
                seated.add(person)
            elif len(table2) < table2_size:
                table2.append(person)
                seated.add(person)

    return table1, table2


def get_table_plan(attendees):
    """
    Generates the table plan in a JSON format compatible with the front-end Flutter.
    :param attendees: List of people marked as present.
    """
    # Define the size of the tables
    table_sizes = (20, 7)

    # Generate the tables using only attendees
    table1, table2 = generate_table_plan(attendees, table_sizes)

    # Convert the data into a readable format
    def format_person(person):
        return {"name": person.name, "gender": person.gender, "family": person.family}

    table1_data = [format_person(person) for person in table1]
    table2_data = [format_person(person) for person in table2]

    # Return the formatted data
    return {"table1": table1_data, "table2": table2_data}
