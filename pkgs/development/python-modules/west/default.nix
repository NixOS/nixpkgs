{ lib, fetchPypi, buildPythonPackage, isPy3k
, colorama, configobj, packaging, pyyaml, pykwalify
}:

buildPythonPackage rec {
  version = "0.7.3";
  pname = "west";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "86a36049ae3c8b1ce12d3183911b3082b38b2998e858285309581e37dc22d8fa";
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
    homepage = "https://github.com/zephyrproject-rtos/west";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
