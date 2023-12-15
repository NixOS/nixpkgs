{ stdenv
, lib
, fetchurl
, makeWrapper
, ghostscript_headless  # for ps2pdf binary
}:

stdenv.mkDerivation rec {
  pname = "ccal";
  version = "2.5.3";
  src = fetchurl {
    url = "https://ccal.chinesebay.com/${pname}-${version}.tar.gz";
    sha256 = "sha256-PUy9yfkFzgKrSEBB+79/C3oxmuajUMbBbWNuGlpQ35Y=";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "CXX:=$(CXX)" "BINDIR=$(out)/bin" "MANDIR=$(out)/share/man" ];
  installTargets = [ "install" "install-man" ];

  # ccalpdf depends on a `ps2pdf` binary in PATH
  postFixup = ''
    wrapProgram $out/bin/ccalpdf \
      --prefix PATH : ${lib.makeBinPath [ ghostscript_headless ]}:$out/bin
  '';

  meta = {
    homepage = "https://ccal.chinesebay.com/ccal.htm";
    description = "Command line Chinese calendar viewer, similar to cal";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sharzy ];
    platforms = lib.platforms.all;
  };
}
