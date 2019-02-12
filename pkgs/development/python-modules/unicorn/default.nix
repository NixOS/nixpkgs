{ stdenv, buildPackages, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  name  = "${pname}-${version}";
  pname = "unicorn";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a5b4vh734b3wfkgapzzf8x18rimpmzvwwkly56da84n27wfw9bg";
  };

  # needs python2 at build time
  PYTHON="${buildPackages.python2.interpreter}";

  setupPyBuildFlags = [ "--plat-name" "linux" ];

  meta = with stdenv.lib; {
    description = "Unicorn CPU emulator engine";
    homepage = "http://www.unicorn-engine.org/";
    license = [ licenses.gpl2 ];
    maintainers = [ maintainers.bennofs ];
  };
}
