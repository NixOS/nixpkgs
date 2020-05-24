{ stdenv
, buildPythonPackage
, fetchPypi
, libpulseaudio
, python3Packages
, extraLibs ? []
}:

buildPythonPackage rec {
  pname = "SoundCard";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01050fe3af635a8880b9f0f2461299e7d52f0ba72bbb1eb60ef3ec67e33609c6";
  };

  #propagatedBuildInputs = [numpy cffi];

  propagatedBuildInputs = with python3Packages; [ numpy cffi ] ++
    [ libpulseaudio ] ++ extraLibs;

  libpulseaudioPath = stdenv.lib.makeLibraryPath [ libpulseaudio ];
  ldWrapperSuffix = "--suffix LD_LIBRARY_PATH : \"${libpulseaudioPath}\"";
  # LC_TIME != C results in locale.Error: unsupported locale setting
  makeWrapperArgs = [ "--set LC_TIME C" ldWrapperSuffix ]; # libpulseaudio.so is loaded manually

  postInstall = ''
    makeWrapper ${python3Packages.python.interpreter} $out/bin/${pname}-python-interpreter \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      ${ldWrapperSuffix}
  '';

  # tests fail
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Play and record audio without resorting to CPython extensions";
    homepage = "https://github.com/bastibe/SoundCard";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
