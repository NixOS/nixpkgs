{ stdenv
, fetchPypi
, buildPythonPackage
, semantic-version
, boto3
, flask
, docutils
}:

buildPythonPackage rec {
  pname = "tiros";
  name = "${pname}-${version}";
  version = "1.0.38";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k668z9gb5vh304gysynj4rxgi24wy2vl4a33dnwkri2g6db3s4n";
  };

  patchPhase = ''
    sed -E -i "s/'([[:alnum:].-_]+)[=><]{2}[[:digit:].]*'/'\\1'/g" setup.py
    sed -i "s/'datetime',//" setup.py
  '';

  propagatedBuildInputs = [ semantic-version boto3 flask docutils ];
}
