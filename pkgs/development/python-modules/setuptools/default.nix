{ stdenv, fetchurl, python, wrapPython, distutils-cfg }:

stdenv.mkDerivation rec {
  shortName = "setuptools-${version}";
  name = "${python.executable}-${shortName}";

  version = "2.0.2";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/s/setuptools/${shortName}.tar.gz";
    sha256 = "09nv5x45y8fgc0kjmmw4gig3hr0is9xlc5rq053vnbmkxr5q5xmi";
  };

  # see https://bitbucket.org/pypa/setuptools/commits/976b839801a3a181f2e14f305ddbe0b410fa8fc0.patch
  patches = [ ./fix_python3_egg_fetcher.patch ];

  buildInputs = [ python wrapPython distutils-cfg ];

  buildPhase = "${python}/bin/${python.executable} setup.py build";

  installPhase =
    ''
      dst=$out/lib/${python.libPrefix}/site-packages
      mkdir -p $dst
      PYTHONPATH="$dst:$PYTHONPATH"
      ${python}/bin/${python.executable} setup.py install --prefix=$out
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
