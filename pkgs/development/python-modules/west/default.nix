{
  lib,
  buildPythonPackage,
  setuptools,
  colorama,
  fetchPypi,
  packaging,
  pykwalify,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "west";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iTIANL6HCZ0W519HYKwNHtZ+iXiSjkaKuZPj+6DP6S8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorama
    packaging
    pyyaml
    pykwalify
  ];

  # pypi package does not include tests (and for good reason):
  # tests run under 'tox' and have west try to git clone repos (not sandboxable)
  doCheck = false;

  pythonImportsCheck = [ "west" ];

  meta = with lib; {
    description = "Zephyr RTOS meta tool";
    mainProgram = "west";
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
