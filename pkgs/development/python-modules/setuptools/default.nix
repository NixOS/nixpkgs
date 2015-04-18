{ stdenv, fetchurl, python, wrapPython, distutils-cfg }:

stdenv.mkDerivation rec {
  shortName = "setuptools-${version}";
  name = "${python.executable}-${shortName}";

  version = "7.0";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/s/setuptools/${shortName}.tar.gz";
    sha256 = "0qg07f035agwcz9m0p3kgdjs18xpl3h00rv28aqsfdyz1wm1m76x";
  };

  buildInputs = [ python wrapPython distutils-cfg ];

  buildPhase = "${python}/bin/${python.executable} setup.py build";

  installPhase =
    ''
      dst=$out/lib/${python.libPrefix}/site-packages
      mkdir -p $dst
      PYTHONPATH="$dst:$PYTHONPATH"
      ${python}/bin/${python.executable} setup.py install --prefix=$out --install-lib=$out/lib/${python.libPrefix}/site-packages
      wrapPythonPrograms
    '';

  doCheck = false;  # requires pytest

  checkPhase = ''
    ${python}/bin/${python.executable} setup.py test
  '';

  meta = with stdenv.lib; {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = http://pypi.python.org/pypi/setuptools;
    license = [ "PSF" "ZPL" ];
    platforms = platforms.all;
  };    
}
