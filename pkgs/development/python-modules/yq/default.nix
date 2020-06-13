{ lib, buildPythonApplication, fetchPypi
, pyyaml, xmltodict, jq
, argcomplete
}:

buildPythonApplication rec {
  pname = "yq";
  version = "2.10.0";

  propagatedBuildInputs = [
    argcomplete
    pyyaml
    xmltodict
    jq
  ];

  # ValueError: underlying buffer has been detached
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ims5q3kfykbyxdfwc3lsrhbcnpgdl56p5rfhpp8vhzi503jrbxb";
  };

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = "https://github.com/kislyuk/yq";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
