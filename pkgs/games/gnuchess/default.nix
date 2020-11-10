{stdenv, fetchurl, flex, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="gnuchess";
    version="6.2.7";
    name="${baseName}-${version}";
    url="mirror://gnu/chess/${name}.tar.gz";
    sha256="0ilq4bfl0lwyzf11q7n2skydjhalfn3bgxhrp5hjxs5bc5d6fdp5";
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
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
