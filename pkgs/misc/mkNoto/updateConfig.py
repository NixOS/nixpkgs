import sys
import yaml

def main():
    file_path = sys.argv[1]
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)

    data["googleFonts"] = False
    data.pop('includeSubsets', None)

    with open(file_path, 'w') as file:
        yaml.safe_dump(data, file)

if __name__ == "__main__":
    main()
