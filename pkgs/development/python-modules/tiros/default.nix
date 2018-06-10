{ stdenv, fetchPypi, buildPythonPackage
, semantic-version, boto3, flask, docutils, requests
}:

buildPythonPackage rec {
  pname = "tiros";
  name = "${pname}-${version}";
  version = "1.0.44";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6bf7410967554ec283f9d4eabc0ce6821d6e6d36001afbdb7fe0826423d4f37";
  };

  patchPhase = ''
    sed -E -i "s/'([[:alnum:].-_]+)[=><]{2}[[:digit:].]*'/'\\1'/g" setup.py
    sed -i "s/'datetime',//" setup.py
  '';

  propagatedBuildInputs = [ semantic-version boto3 flask docutils requests ];
}
