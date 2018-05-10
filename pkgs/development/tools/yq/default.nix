{ stdenv, lib, buildPythonApplication, fetchPypi, pyyaml, xmltodict, jq }:

buildPythonApplication rec {
  pname = "yq";
  version = "2.5.0";

  propagatedBuildInputs = [ pyyaml xmltodict jq ];

  # ValueError: underlying buffer has been detached
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9fd2aa32defcd051058e3b6f665873282aa4eed19e11b1db94fe70847535d4c";
  };

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = https://github.com/kislyuk/yq;
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
