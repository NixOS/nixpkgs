{ lib, buildPythonApplication, fetchPypi, pyyaml, xmltodict, jq }:

buildPythonApplication rec {
  pname = "yq";
  version = "2.7.2";

  propagatedBuildInputs = [ pyyaml xmltodict jq ];

  # ValueError: underlying buffer has been detached
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fwvwy75n4rqzh6sxyp2jmjqc7939s0xmrhxw7zhdy6iacggvnpp";
  };

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = https://github.com/kislyuk/yq;
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
