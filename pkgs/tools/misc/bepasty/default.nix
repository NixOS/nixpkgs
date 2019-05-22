{ python3Packages
, fetchpatch
, lib
}:

with python3Packages;

#We need to use buildPythonPackage here to get the PYTHONPATH build correctly.
#This is needed for services.bepasty
#https://github.com/NixOS/nixpkgs/pull/38300
buildPythonPackage rec {
  pname = "bepasty";
  version = "0.5.0";

  patches = [
    # Fix for bytes under Python 3
    # See https://github.com/bepasty/bepasty-server/issues/200
    (fetchpatch {
      url = "https://github.com/bepasty/bepasty-server/commit/4678896d71ae9e217e34e25600494ce5b740d922.patch";
      sha256 = "031j17l07qg2k31x3dpjjasmampj54izndvd1xlfianbg4v67wcq";
    })
  ];

  propagatedBuildInputs = [
    flask
    pygments
    xstatic
    xstatic-bootbox
    xstatic-bootstrap
    xstatic-jquery
    xstatic-jquery-file-upload
    xstatic-jquery-ui
    xstatic-pygments
  ];

  buildInputs = [ setuptools_scm ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y3smw9620w2ia4zfsl2svb9j7mkfgc8z1bzjffyk1w5vryhwikh";
  };

  checkInputs = [
    pytest
    selenium
  ];

  meta = {
    homepage = https://github.com/bepasty/bepasty-server;
    description = "Binary pastebin server";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.makefu ];
  };
}
