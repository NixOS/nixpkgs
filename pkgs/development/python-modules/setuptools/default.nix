{ stdenv, fetchurl, python, wrapPython, distutils-cfg }:

stdenv.mkDerivation rec {
  shortName = "setuptools-${version}";
  name = "${python.executable}-${shortName}";

  version = "2.1";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/s/setuptools/${shortName}.tar.gz";
    sha256 = "1m8qjvj5bfbphdags5s6pgmvk3xnw509lgdlq9whkq5a9mgxf8m7";
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

  doCheck = stdenv.system != "x86_64-darwin";

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
