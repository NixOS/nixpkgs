{lib, stdenv, fetchurl, flex, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="gnuchess";
    version="6.2.9";
    name="${baseName}-${version}";
    url="mirror://gnu/chess/${name}.tar.gz";
    sha256="sha256-3fzCC911aQCpq2xCx9r5CiiTv38ZzjR0IM42uuvEGJA=";
  };
  buildInputs = [
    flex
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  src = fetchurl {
    inherit (s) url sha256;
  };
  inherit buildInputs;
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/gnuchessx --set PATH "$out/bin"
    wrapProgram $out/bin/gnuchessu --set PATH "$out/bin"
  '';

  meta = {
    inherit (s) version;
    description = "GNU Chess engine";
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
  };
}
