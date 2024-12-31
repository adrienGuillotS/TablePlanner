from classes import Person, Family

family1 = Family(
    "Chaufour",
    [
        Person("Mamoune", "Female", "Chaufour"),
        Person("Polo", "Male", "Chaufour"),
    ],
)
family2 = Family(
    "ChaufourDablanc",
    [
        Person("Suzie", "Female", "ChaufourDablanc"),
        Person("Oscar", "Male", "ChaufourDablanc"),
        Person("Juliette", "Female", "ChaufourDablanc"),
        Person("Romain", "Male", "ChaufourDablanc"),
    ],
)
family3 = Family(
    "Guillot",
    [
        Person("JB", "Male", "Guillot"),
        Person("Séverine", "Female", "Guillot"),
        Person("Alix", "Female", "Guillot"),
        Person("Maxou", "Male", "Guillot"),
        Person("Sixtine", "Female", "Guillot"),
        Person("Adrien", "Male", "Guillot"),
    ],
)
family4 = Family(
    "Cubertafond",
    [
        Person("Judith", "Female", "Cubertafond"),
        Person("MartinCub", "Male", "Cubertafond"),
        Person("Honorine", "Female", "Cubertafond"),
        Person("Dazz", "Male", "Cubertafond"),
        Person("Elise", "Female", "Cubertafond"),
    ],
)
family5 = Family(
    "Poulain",
    [
        Person("Kieran", "Male", "Poulain"),
        Person("Marie", "Female", "Poulain"),
        Person("Melchior", "Male", "Poulain"),
        Person("Alma", "Female", "Poulain"),
        Person("Amaury", "Male", "Poulain"),
    ],
)
family6 = Family(
    "ChaufourHauret",
    [
        Person("Martin", "Male", "ChaufourHauret"),
        Person("Carine", "Female", "ChaufourHauret"),
        Person("Ernest", "Male", "ChaufourHauret"),
        Person("Stan", "Male", "ChaufourHauret"),
        Person("Laure", "Female", "ChaufourHauret"),
    ],
)

people = (
    family1.members
    + family2.members
    + family3.members
    + family4.members
    + family5.members
    + family6.members
)
