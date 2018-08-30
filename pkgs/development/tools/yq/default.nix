{ lib, buildPythonApplication, fetchPypi, pyyaml, xmltodict, jq }:

buildPythonApplication rec {
  pname = "yq";
  version = "2.6.0";

  propagatedBuildInputs = [ pyyaml xmltodict jq ];

  # ValueError: underlying buffer has been detached
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wyzg6lwxmzqsblljg9hddkadda7qdpw54sp0pmmbv89hhz7cky6";
  };

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = https://github.com/kislyuk/yq;
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
