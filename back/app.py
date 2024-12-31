from flask import Flask, jsonify, request
from flask_cors import CORS
from people import people
from table_planner import generate_table_plan
from classes import Person
import logging

app = Flask(__name__)
CORS(app)  # Allow all origins by default

logging.basicConfig(level=logging.DEBUG)


@app.route("/get-plan", methods=["POST"])
def get_table_plan_endpoint():
    """
    Generate the table plan only with the present attendees.
    """
    try:
        # Get present attendees from the POST request
        data = request.get_json()
        if not data or "people" not in data:
            raise ValueError("Invalid request data: 'people' key is missing")

        present_people = data["people"]
        attendees = [
            Person(person["name"], person["gender"], person["family"])
            for person in present_people
        ]

        # Define table sizes
        table_sizes = (20, 7)

        # Generate the table plan
        table1, table2 = generate_table_plan(attendees, table_sizes)

        def format_person(person):
            return {
                "name": person.name,
                "gender": person.gender,
                "family": person.family,
            }

        table1_data = [format_person(person) for person in table1]
        table2_data = [format_person(person) for person in table2]

        logging.info(f"Table 1 Plan: {table1_data}")
        logging.info(f"Table 2 Plan: {table2_data}")
        return jsonify({"table1": table1_data, "table2": table2_data}), 200
    except ValueError as ve:
        logging.error(f"Invalid input error: {ve}")
        return jsonify({"error": str(ve)}), 400
    except Exception as e:
        logging.error(f"Error generating table plan: {e}")
        return jsonify({"error": "Internal server error"}), 500


@app.route("/get-people", methods=["GET"])
def get_people():
    """
    Route to retrieve the list of all people.
    """
    try:
        people_data = [
            {"name": person.name, "gender": person.gender, "family": person.family}
            for person in people
        ]
        return jsonify(people_data), 200
    except Exception as e:
        logging.error(f"Error retrieving people: {e}")
        return jsonify({"error": "Internal server error"}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
