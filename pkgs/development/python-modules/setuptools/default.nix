{ fetchurl, stdenv, python, makeWrapper }:

stdenv.mkDerivation rec {
  name = "setuptools-0.6c9";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/s/setuptools/${name}.tar.gz";
    sha256 = "1n5k6hf9nn69fnprgsnr9hdxzj2j6ir76qcy9d4b2v0v62bh86g6";
  };

  buildInputs = [ python makeWrapper ];

  doCheck = true;

  buildPhase     = "python setup.py build --build-base $out";
  checkPhase     = "python setup.py test";

  installPhase   = ''
    ensureDir "$out/lib/python2.5/site-packages"

    PYTHONPATH="$out/lib/python2.5/site-packages:$PYTHONPATH" \
    python setup.py install --prefix="$out"

    for i in "$out/bin/"*
    do
      wrapProgram "$i"                          \
        --prefix PYTHONPATH ":"			\
          "$out/lib/python2.5/site-packages"
    done
  '';

  meta = {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = http://pypi.python.org/pypi/setuptools;
    licenses = [ "PSF" "ZPL" ];
  };
}
