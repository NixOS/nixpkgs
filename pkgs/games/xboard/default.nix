{stdenv, fetchurl, libX11, xproto, libXt, libXaw, libSM, libICE, libXmu
, libXext, gnuchess, texinfo, libXpm
}:
let
  s = # Generated upstream information
  rec {
    baseName="xboard";
    version="4.6.2";
    name="${baseName}-${version}";
    hash="1pw90fh1crf0nkqyql54z728vn2093hwdh2v5i5703z9qv9g4mrf";
    url="http://ftp.gnu.org/gnu/xboard/xboard-4.6.2.tar.gz";
    sha256="1pw90fh1crf0nkqyql54z728vn2093hwdh2v5i5703z9qv9g4mrf";
  };
  buildInputs = [
    libX11 xproto libXt libXaw libSM libICE libXmu 
    libXext gnuchess texinfo libXpm
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  meta = {
    inherit (s) version;
    description = ''GUI for chess engines'';
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
