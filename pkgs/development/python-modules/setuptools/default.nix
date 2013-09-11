{ stdenv, fetchurl, python, wrapPython }:

stdenv.mkDerivation rec {
  shortName = "setuptools-${version}";
  name = "${python.executable}-${shortName}";

  version = "0.9.8";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/s/setuptools/${shortName}.tar.gz";
    sha256 = "037b8x3fdhx8s6xafqndi3yr8x2vr42n1kzs7jxk6j9s9fd65gs2";
  };

  patches = [
    # https://bitbucket.org/pypa/setuptools/issue/55/1-failure-lc_all-c-python33m-setuppy-test
    ./distribute-skip-sdist_with_utf8_encoded_filename.patch
  ];

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

  # tests fail on darwin, see http://bitbucket.org/pypa/setuptools/issue/55/1-failure-lc_all-c-python33m-setuppy-test 
  doCheck = (!stdenv.isDarwin);

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
