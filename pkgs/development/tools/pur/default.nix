{ lib
, python3
, fetchFromGitHub
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      # newest version doesn't support click >8.0 https://github.com/alanhamlett/pip-update-requirements/issues/38
      click = self.callPackage ../../../development/python-modules/click/7.nix { };
    };
  };
  inherit (py.pkgs) buildPythonApplication click pytestCheckHook;
in

buildPythonApplication rec {
  pname = "pur";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "alanhamlett";
    repo = "pip-update-requirements";
    rev = version;
    sha256 = "sha256-coJO9AYm0Qx0arMf/e+pZFG/VxK6bnxxXRgw7x7V2hY=";
  };

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pur" ];

  meta = with lib; {
    description = "Python library for update and track the requirements";
    homepage = "https://github.com/alanhamlett/pip-update-requirements";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
