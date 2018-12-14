{ lib, buildPythonApplication, fetchPypi, pyyaml, xmltodict, jq }:

buildPythonApplication rec {
  pname = "yq";
  version = "2.7.1";

  propagatedBuildInputs = [ pyyaml xmltodict jq ];

  # ValueError: underlying buffer has been detached
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c10wbhgx8d8s44a8g2vzn4cmvkf7z7yqxrnk88aapgi51i786q0";
  };

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = https://github.com/kislyuk/yq;
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
