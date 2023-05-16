{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, click
, pip
, setuptools
, wheel
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "shiv";
<<<<<<< HEAD
  version = "1.0.4";
=======
  version = "1.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-j2n3gXolRalMyOB6jsWXN1z4biwb0OWD7nU9bzH4UGA=";
=======
    hash = "sha256-vxRv8/Oryi6xIU6GAY82EkocItk1QO71JAMhys19f1c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ click pip setuptools wheel ];

  pythonImportsCheck = [ "shiv" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AssertionError
    "test_hello_world"
    "test_extend_pythonpath"
    "test_multiple_site_packages"
    "test_no_entrypoint"
    "test_results_are_binary_identical_with_env_and_build_id"
    "test_preamble"
    "test_preamble_no_pip"
    "test_alternate_root"
    "test_alternate_root_environment_variable"
  ];

  meta = with lib; {
    description = "Command line utility for building fully self contained Python zipapps";
    homepage = "https://github.com/linkedin/shiv";
    license = licenses.bsd2;
    maintainers = with maintainers; [ prusnak ];
  };
}
