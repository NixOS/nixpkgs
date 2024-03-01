{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pillow
}:

buildPythonPackage rec {
  pname = "vacuum-map-parser-base";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Python-package-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-moCWUPzn9stxehVEnjqpx8ILYhxzuy8QG+uxR53rCew=";
  };

  postPatch = ''
    # Upstream doesn't set a version in the pyproject.toml file
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}"
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ pillow ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "vacuum_map_parser_base" ];

  meta = with lib; {
    homepage = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-base";
    description = "Common code for vacuum map parsers";
    changelog = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-base/releases/tag/v${version}";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.asl20;
  };
}
