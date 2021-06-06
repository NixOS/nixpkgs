{lib, stdenv, fetchurl, flex, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="gnuchess";
    version="6.2.8";
    name="${baseName}-${version}";
    url="mirror://gnu/chess/${name}.tar.gz";
    sha256="0irqb0wl30c2i1rs8f6mm1c89l7l9nxxv7533lr408h1m36lc16m";
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
