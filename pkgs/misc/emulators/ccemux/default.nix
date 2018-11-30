{ stdenv, fetchurl, fetchFromGitHub, makeDesktopItem, makeWrapper, jre
, useCCTweaked ? true
}:

let
  version = "1.1.0";
  rev = "a12239148332ca7a0b1c44a93e1585452d3631c9";

  baseUrl = "https://emux.cc/versions/${stdenv.lib.substring 0 8 rev}/CCEmuX";
  jar =
    if useCCTweaked
    then fetchurl {
      url = "${baseUrl}-cct.jar";
      sha256 = "1i767v3wnb8jsh7ciqqvw548pka1b8vl18k1rdv5dn21la6n0r1d";
    }
    else fetchurl {
      url = "${baseUrl}-cc.jar";
      sha256 = "0x9hs814ln193cwybd565mcj6vhnii4wirkiz9na7vcas0y5vmmq";
    };

  desktopIcon = fetchurl {
    url = "https://github.com/CCEmuX/CCEmuX/raw/${rev}/src/main/resources/img/icon.png";
    sha256 = "1vmb6rg9k2y99j8xqfgbsvfgfi3g985rmqwrd7w3y54ffr2r99c2";
  };
  desktopItem =  makeDesktopItem {
    name = "CCEmuX";
    exec = "ccemux";
    icon = "${desktopIcon}";
    comment = "A modular ComputerCraft emulator";
    desktopName = "CCEmuX";
    genericName = "ComputerCraft Emulator";
    categories = "Application;Emulator;";
  };
in

stdenv.mkDerivation rec {
  name = "ccemux-${version}";

  src = jar;
  unpackPhase = "true";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/ccemux}
    cp -r ${desktopItem}/share/applications $out/share/applications

    install -D ${src} $out/share/ccemux/ccemux.jar
    install -D ${desktopIcon} $out/share/pixmaps/ccemux.png

    makeWrapper ${jre}/bin/java $out/bin/ccemux \
      --add-flags "-jar $out/share/ccemux/ccemux.jar"

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A modular ComputerCraft emulator";
    homepage = https://github.com/CCEmuX/CCEmuX;
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
  };
}
