{stdenv, fetchurl, oniguruma}:
let
  s = # Generated upstream information
  rec {
    baseName="jq";
    version="1.5";
    name="${baseName}-${version}";
    url="https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz";
    sha256="0g29kyz4ykasdcrb0zmbrp2jqs9kv1wz9swx849i2d1ncknbzln4";
  };
  buildInputs = [
    oniguruma
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  # jq is linked to libjq:
  configureFlags = [
    "LDFLAGS=-Wl,-rpath,\\\${libdir}"
  ];
  meta = {
    inherit (s) version;
    description = ''A lightweight and flexible command-line JSON processor'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
