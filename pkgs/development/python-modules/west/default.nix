{ lib
, buildPythonPackage
, colorama
, configobj
, fetchPypi
, packaging
, pykwalify
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "west";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-40h/VLa9kEWASJtgPvGm4JnG8uZWAUwrg8SzwhdfpN8=";
=======
    hash = "sha256-ZvhwIhkoES71jyv8Xv0dd44Z7tFAZzmE2XsiH7wFJfQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    colorama
    configobj
    packaging
    pyyaml
    pykwalify
  ];

  # pypi package does not include tests (and for good reason):
  # tests run under 'tox' and have west try to git clone repos (not sandboxable)
  doCheck = false;

  pythonImportsCheck = [
    "west"
  ];

  meta = with lib; {
    description = "Zephyr RTOS meta tool";
    longDescription = ''
      West lets you manage multiple Git repositories under a single directory using a single file,
      called the west manifest file, or manifest for short.

      The manifest file is named west.yml.
      You use west init to set up this directory,
      then west update to fetch and/or update the repositories
      named in the manifest.

      By default, west uses upstream Zephyr’s manifest file
      (https://github.com/zephyrproject-rtos/zephyr/blob/master/west.yml),
      but west doesn’t care if the manifest repository is a Zephyr tree or not.

      For more details, see Multiple Repository Management in the west documentation
      (https://docs.zephyrproject.org/latest/guides/west/repo-tool.html).
    '';
    homepage = "https://github.com/zephyrproject-rtos/west";
    changelog = "https://github.com/zephyrproject-rtos/west/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
