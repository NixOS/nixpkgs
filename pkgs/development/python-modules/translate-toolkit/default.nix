{ stdenv
, fetchPypi
, buildPythonPackage
, six
, diff-match-patch
, lxml
, python-Levenshtein
, chardet
, pycountry
, pytest
}:

buildPythonPackage rec {
  pname = "translate-toolkit";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jscg7mc7i22szfmg7r7b3msgk5w6cpx9fi4kr1dbwpx36j2acvn";
  };

  propagatedBuildInputs = [
    six diff-match-patch lxml python-Levenshtein chardet pycountry
  ];
  checkInputs = [ pytest ];

  # test_xliff_conformance requires network
  checkPhase = ''
    py.test -k 'not test_xliff_conformance' tests
  '';

  meta = with stdenv.lib; {
    description = "Useful localization tools for building localization & translation systems";
    homepage = https://toolkit.translatehouse.org/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ phile314 jtojnar ];
  };
}
