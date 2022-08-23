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
  version = "0.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B6B7shZ8FM5pyXzXknJv9mwr+ERq4kiEzRf5jLTCicM=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
