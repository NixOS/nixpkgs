{stdenv, fetchurl, flex, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="gnuchess";
    version="6.2.6";
    name="${baseName}-${version}";
    url="mirror://gnu/chess/${name}.tar.gz";
    sha256="0kxhdv01ia91v2y0cmzbll391ns2vbmn65jjrv37h4s1srszh5yn";
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
