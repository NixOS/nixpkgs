{ stdenv, fetchPypi, buildPythonPackage
, semantic-version, boto3, flask, docutils, requests
}:

buildPythonPackage rec {
  pname = "tiros";
  name = "${pname}-${version}";
  version = "1.0.39";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10wh84lpl7k8i69hlxwrzp2lln63w2afv9l7ij7r3lqjwd0z0skr";
  };

  patchPhase = ''
    sed -E -i "s/'([[:alnum:].-_]+)[=><]{2}[[:digit:].]*'/'\\1'/g" setup.py
    sed -i "s/'datetime',//" setup.py
  '';

  propagatedBuildInputs = [ semantic-version boto3 flask docutils requests ];
}
