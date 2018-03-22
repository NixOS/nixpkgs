{ stdenv, lib, buildPythonApplication, fetchPypi, pyyaml, xmltodict, jq }:

buildPythonApplication rec {
  pname = "yq";
  version = "2.4.1";

  propagatedBuildInputs = [ pyyaml xmltodict jq ];

  # ValueError: underlying buffer has been detached
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4833d4055b0f1c1f1a2fd292421b3472da39c7dc2727d7819efd11065a5fd310";
  };

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = https://github.com/kislyuk/yq;
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
