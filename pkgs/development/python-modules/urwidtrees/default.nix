{ lib
, buildPythonPackage
, fetchFromGitHub
, glibcLocales
, urwid
, fetchpatch
}:

buildPythonPackage rec {
  pname = "urwidtrees";
  format = "setuptools";
  version  = "1.0.3";

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "urwidtrees";
    rev = version;
    hash = "sha256-yGSjwagCd5TiwEFtF6ZhDuVqj4PTa5pVXhs8ebr2O/g=";
  };

  propagatedBuildInputs = [ urwid ];

  patches = [
    (fetchpatch {
      url = "https://github.com/pazz/urwidtrees/commit/ed39dbc4fc67b0e0249bf108116a88cd18543aa9.patch";
    hash = "sha256-fA+30d2uVaoNCg4rtoWLNPvrZtq41Co4vcmM80hkURs=";
    })
  ];

  nativeCheckInputs = [ glibcLocales ];
  LC_ALL="en_US.UTF-8";

  meta = with lib; {
    description = "Tree widgets for urwid";
    homepage = "https://github.com/pazz/urwidtrees";
    license = licenses.gpl3;
  };

}
