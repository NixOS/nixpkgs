{ fetchPypi, unzip, stdenv, pname, version, jarHash }:

stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    hash = jarHash;
  };

  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    unzip ${src}
    mv ./skein/java/skein.jar $out
  '';
}
