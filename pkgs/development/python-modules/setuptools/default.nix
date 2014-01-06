{ stdenv, fetchurl, python, wrapPython }:

stdenv.mkDerivation rec {
  shortName = "setuptools-${version}";
  name = "${python.executable}-${shortName}";

  version = "2.0.2";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/s/setuptools/${shortName}.tar.gz";
    sha256 = "09nv5x45y8fgc0kjmmw4gig3hr0is9xlc5rq053vnbmkxr5q5xmi";
  };

  buildInputs = [ python wrapPython ];

  buildPhase = "${python}/bin/${python.executable} setup.py build --build-base $out";

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
    licenses = [ "PSF" "ZPL" ];
    platforms = platforms.all;
  };    
}
