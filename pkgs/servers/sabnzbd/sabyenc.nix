{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "sabyenc";
  version = "3.3.2";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "107gb8rzsk4ir0dcshvz1labammy8896v8byb7989x6pzapkikmj";
  };

  meta = {
    homepage = https://github.com/sabnzbd/sabyenc;
    description = "Python yEnc package optimized for use within SABnzbd";
    license = lib.licenses.lgpl3;
  };
}
