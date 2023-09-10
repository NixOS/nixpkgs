{ lib
, python3
, fetchFromGitHub
}:

let
  pname = "wtfis";
  version = "0.6.1";
in python3.pkgs.buildPythonApplication {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "pirxthepilot";
    repo = "wtfis";
    rev = "refs/tags/v${version}";
    hash = "sha256-bHgv5+HoM1hFhpkqml+HxqiMDvKbMqsTH+zYtDrV7Ko=";
  };

  patches = [
    # TODO: get rid of that newbie patch
    ./000-pyproject-remove-versions.diff
  ];

  format = "pyproject";

  propagatedBuildInputs = [
    python3.pkgs.hatchling
    python3.pkgs.pydantic
    python3.pkgs.rich
    python3.pkgs.shodan
    python3.pkgs.python-dotenv
  ];

  meta = {
    homepage = "https://github.com/pirxthepilot/wtfis";
    description = "Passive hostname, domain and IP lookup tool for non-robots";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.AndersonTorres ];
  };
}
