"""
main.py
Simple command-line menu for demonstrating the project.

Run from the python folder:
    python main.py
"""

from equipment_operations import get_all_equipment, search_equipment
from request_operations import get_active_requests
from reports import dashboard_summary, requests_by_status, equipment_maintenance_history

try:
    from tabulate import tabulate
except ImportError:
    tabulate = None


def print_rows(rows, title):
    """Print query results as a table if tabulate is installed."""
    print("\n" + title)
    print("-" * len(title))

    if not rows:
        print("No records found.")
        return

    if tabulate:
        print(tabulate(rows, headers="keys", tablefmt="grid"))
    else:
        for row in rows:
            print(dict(row))


def show_dashboard():
    summary = dashboard_summary()
    print("\nDashboard Summary")
    print("-----------------")
    if summary is None:
        print("Could not load dashboard summary.")
        return

    for key, value in summary.items():
        readable_key = key.replace("_", " ").title()
        print(f"{readable_key}: {value}")


def menu():
    while True:
        print("\nEquipment Maintenance and Workover Request Tracking System")
        print("1. Show all equipment")
        print("2. Search equipment")
        print("3. Show active requests")
        print("4. Show dashboard summary")
        print("5. Show requests by status")
        print("6. Show maintenance history")
        print("0. Exit")

        choice = input("Choose an option: ").strip()

        if choice == "1":
            rows = get_all_equipment()
            print_rows(rows, "All Equipment")
        elif choice == "2":
            keyword = input("Enter search keyword: ").strip()
            rows = search_equipment(keyword)
            print_rows(rows, f"Search Results for '{keyword}'")
        elif choice == "3":
            rows = get_active_requests()
            print_rows(rows, "Active Requests")
        elif choice == "4":
            show_dashboard()
        elif choice == "5":
            rows = requests_by_status()
            print_rows(rows, "Requests by Status")
        elif choice == "6":
            rows = equipment_maintenance_history()
            print_rows(rows, "Equipment Maintenance History")
        elif choice == "0":
            print("Exiting program. Goodbye!")
            break
        else:
            print("Invalid option. Please try again.")


if __name__ == "__main__":
    menu()
