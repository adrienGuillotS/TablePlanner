import logging
import random

# Set up logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def can_seat(person, table):
    if not table:
        return True
    last_person = table[-1]
    if person.gender == last_person.gender:
        logger.debug(f"Cannot seat {person.name} because of gender constraint with {last_person.name}")
        return False
    if person.family == last_person.family:
        logger.debug(f"Cannot seat {person.name} because they are from the same family as {last_person.name}")
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
        logger.debug(f"Current Person: {person.name}")
        
        if len(table1) < table1_size:
            # Try seating at Table 1
            if person not in seated and can_seat(person, table1):
                logger.debug(f"Can seat {person.name} at Table 1")
                table1.append(person)
                seated.add(person)
            else:
                # Try to seat the next available person if this one cannot be seated
                for next_person in attendees:
                    logger.debug(f"Next Person: {next_person.name}")
                    if next_person not in seated and can_seat(next_person, table1):
                        logger.debug(f"{next_person.name} can seat at Table 1")
                        table1.append(next_person)
                        seated.add(next_person)
                        break  # Proceed to next person after seating
                else:
                    # If no suitable next person is found, force seat the current person
                    if person not in seated:
                        table1.append(person)
                        seated.add(person)
                        logger.debug(f"Forcing seat for {person.name} at Table 1")
            logger.debug(f"Current Table 1: {[p.name for p in table1]}")
            logger.debug(f"Seated Attendees: {[p.name for p in seated]}")
            logger.debug("-" * 50)
        elif len(table2) < table2_size:
            if person not in seated and can_seat(person, table2):
                logger.debug(f"Can seat {person.name} at Table 2")
                table2.append(person)
                seated.add(person)
            else:
                # Try to seat the next available person at Table 2
                seated_next = False
                for next_person in attendees:
                    logger.debug(f"Next Person: {next_person.name}")
                    if next_person not in seated and can_seat(next_person, table2):
                        logger.debug(f"{next_person.name} can seat at Table 2")
                        table2.append(next_person)
                        seated.add(next_person)
                        seated_next = True
                        break  # Break once we've seated the next available person

                if not seated_next:
                    # If no suitable next person is found, force seat the current person
                    if person not in seated:
                        logger.debug(f"Forcing seat for {person.name} at Table 2")
                        table2.append(person)
                        seated.add(person)
            logger.debug(f"Current Table 2: {[p.name for p in table2]}")
            logger.debug(f"Seated Attendees: {[p.name for p in seated]}")
            logger.debug("-" * 50)

    # Force-seat any remaining attendees
    for person in attendees:
        if person not in seated:
            if len(table1) < table1_size:
                table1.append(person)
                seated.add(person)
            elif len(table2) < table2_size:
                table2.append(person)
                seated.add(person)
    # Ensure Polo is seated at the second-last position in Table 1
    polo_index = next((i for i, person in enumerate(table1) if person.name == "Polo"), None)
    if polo_index is not None and polo_index != len(table1) - 2:
        polo = table1.pop(polo_index)
        table1.insert(len(table1) - 1, polo)
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
