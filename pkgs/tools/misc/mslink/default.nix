{ gccStdenv
, lib
, fetchurl
}:

gccStdenv.mkDerivation rec {
  pname = "mslink";
  version = "1.3";

  src = fetchurl {
    url = "http://www.mamachine.org/mslink/mslink_v${version}.tar.gz";
    sha256 = "1qiwqa6w2in6gk4sxiy37c2wwpakin6l2ad2cf5s7ij96z2ijgqg";
  };

  preBuild = ''
    rm mslink # clean up shipped executable
  '';

  installPhase = ''
    if [[ "$(uname)" == "Darwin" ]]; then
      mv mslink.exe mslink
    fi
    install -D mslink $out/bin/mslink
  '';

  meta = with lib; {
    description = "Create Windows Shortcut Files (.LNK) without using Windows";
    homepage = "http://www.mamachine.org/mslink/index.en.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.unix;
    mainProgram = "mslink";
  };
}
