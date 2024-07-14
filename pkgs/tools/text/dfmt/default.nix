{ lib
, python3
, fetchPypi
}:

let
  inherit (python3.pkgs)
    buildPythonApplication
    pythonOlder;
in
buildPythonApplication rec {
  pname = "dfmt";
  version = "1.2.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-evY2DKjVVvHP6CuX8DuNHqWp1t4fowGCkMhEtlZtnW4=";
  };

  meta = with lib; {
    description = "Format paragraphs, comments and doc strings";
    mainProgram = "dfmt";
    homepage = "https://github.com/dmerejkowsky/dfmt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cole-h ];
  };
}
