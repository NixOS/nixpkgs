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
  version = "1.0.40";

  src = fetchPypi {
    inherit pname version;
    sha256 = "841ca13564e3cddfd1404cbc60b3433bcc1e31c2753ecea20d0ad68173b80169";
  };

  patchPhase = ''
    sed -E -i "s/'([[:alnum:].-_]+)[=><]{2}[[:digit:].]*'/'\\1'/g" setup.py
    sed -i "s/'datetime',//" setup.py
  '';

  propagatedBuildInputs = [ semantic-version boto3 flask docutils ];
}
