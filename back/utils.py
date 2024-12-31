def format_tables(table1, table2):
    def format_person(person):
        return f"{person.name} ({person.family})"

    table1_str = ", ".join([format_person(person) for person in table1])
    table2_str = ", ".join([format_person(person) for person in table2])
    return f"Table 1: [{table1_str}]\nTable 2: [{table2_str}]"
