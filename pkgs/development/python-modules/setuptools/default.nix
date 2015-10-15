{ stdenv, fetchurl, python, wrapPython, distutils-cfg }:

stdenv.mkDerivation rec {
  shortName = "setuptools-${version}";
  name = "${python.executable}-${shortName}";

  version = "18.4";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/s/setuptools/${shortName}.tar.gz";
    sha256 = "07qigmdgm6pard6gwlgj5n7cm0f43nk271ymacsdhjhbwsc51snd";
  };

  buildInputs = [ python wrapPython distutils-cfg ];

  buildPhase = "${python}/bin/${python.executable} setup.py build";

  installPhase =
    ''
      dst=$out/lib/${python.libPrefix}/site-packages
      mkdir -p $dst
      export PYTHONPATH="$dst:$PYTHONPATH"
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
