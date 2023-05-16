{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.46";
<<<<<<< HEAD
        src = fetchPypi {
=======
        src = super.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          pname = "SQLAlchemy";
          inherit version;
          hash = "sha256-aRO4JH2KKS74MVFipRkx4rQM6RaB8bbxj2lwRSAMSjA=";
        };
<<<<<<< HEAD
        disabledTestPaths = [
           "test/aaa_profiling"
           "test/ext/mypy"
=======
        nativeCheckInputs = oldAttrs.nativeCheckInputs ++ (with super; [
          pytest-xdist
        ]);
        disabledTestPaths = (oldAttrs.disabledTestPaths or []) ++ [
          "test/aaa_profiling"
          "test/ext/mypy"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "csvkit";
  version = "1.1.1";
  format = "setuptools";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    hash = "sha256-vt23t49rIq2+1urVrV3kv7Md0sVfMhGyorO2VSkEkiM=";
  };

  propagatedBuildInputs = with python.pkgs; [
    agate
    agate-excel
    agate-dbf
    agate-sql
<<<<<<< HEAD
    setuptools # csvsql imports pkg_resources
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "csvkit"
  ];

  disabledTests = [
    # Test is comparing CLI output
    "test_decimal_format"
  ];

  meta = with lib; {
    changelog = "https://github.com/wireservice/csvkit/blob/${version}/CHANGELOG.rst";
    description = "A suite of command-line tools for converting to and working with CSV";
    homepage = "https://github.com/wireservice/csvkit";
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
  };
}
