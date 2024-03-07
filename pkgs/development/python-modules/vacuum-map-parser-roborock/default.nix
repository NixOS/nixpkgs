{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pillow
, vacuum-map-parser-base
}:

buildPythonPackage rec {
  pname = "vacuum-map-parser-roborock";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Python-package-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-cZNmoqzU73iF965abFeM6qgEVmg6j2kIQHDhj1MYQpE=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pillow
    vacuum-map-parser-base
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "vacuum_map_parser_roborock" ];

  meta = with lib; {
    homepage = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-roborock";
    description = "Functionalities for Roborock vacuum map parsing";
    changelog = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-roborock/releases/tag/v${version}";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.asl20;
  };
}
