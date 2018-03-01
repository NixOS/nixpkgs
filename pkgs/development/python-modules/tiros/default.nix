{ stdenv, fetchPypi, buildPythonPackage
, semantic-version, boto3, flask, docutils, requests
}:

buildPythonPackage rec {
  pname = "tiros";
  name = "${pname}-${version}";
  version = "1.0.42";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0f9bc6d463654c971a78e02a3159ec62a2db684a217a7e940e66d4a381bdd52";
  };

  patchPhase = ''
    sed -E -i "s/'([[:alnum:].-_]+)[=><]{2}[[:digit:].]*'/'\\1'/g" setup.py
    sed -i "s/'datetime',//" setup.py
  '';

  propagatedBuildInputs = [ semantic-version boto3 flask docutils requests ];
}
