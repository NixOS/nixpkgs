{ stdenv, fetchurl, python, xrandr, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "arandr-0.1.7.1";

  src = fetchurl {
    url = "http://christian.amsuess.com/tools/arandr/files/${name}.tar.gz";
    sha256 = "1nj84ww1kf024n5xgxwqmzscv8i1gixx7nmg05dbjj2xs28alwxb";
  };

  buildPhase = ''
    rm -rf data/po/*
    python setup.py build
  '';

  # no tests
  doCheck = false;

  buildInputs = [pythonPackages.docutils];
  propagatedBuildInputs = [ xrandr pythonPackages.pygtk ];

  meta = {
    homepage = http://christian.amsuess.com/tools/arandr/;
    description = "A simple visual front end for XRandR";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.iElectric ];
  };
}
