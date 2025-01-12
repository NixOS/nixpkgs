{
  fetchPypi,
  unzip,
  stdenv,
  pname,
  version,
  jarHash,
}:

stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    dist = "py3";
    hash = jarHash;
  };

  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    unzip ${src}
    install -D ./skein/java/skein.jar $out
  '';
}
