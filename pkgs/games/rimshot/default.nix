{ stdenv, fetchurl, unzip, love, lua, makeWrapper, makeDesktopItem }:

let
  pname = "rimshot";
  version = "1.0";

  icon = fetchurl {
    url = "http://stabyourself.net/images/screenshots/rimshot-2.png";
    sha256 = "08fyiqym3gcpq2vgb5dvafkban42fsbzfcr3iiyw03hz99q53psd";
  };

  desktopItem = makeDesktopItem {
    name = "rimshot";
    exec = "${pname}";
    icon = "${icon}";
    comment = "Create your own music";
    desktopName = "Rimshot";
    genericName = "rimshot";
    categories = "Audio;AudioVideo;Music";
  };

in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://stabyourself.net/dl.php?file=${pname}/${pname}-source.zip";
    sha256 = "08pdkyvki92549605m9bqnr24ipkbwkp5nkr5aagdqnr8ai4rgmi";
  };

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ lua love ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip -j $src
  '';  

  installPhase =
  ''
    mkdir -p $out/bin
    mkdir -p $out/share/games/lovegames

    cp -v ./*.love $out/share/games/lovegames/${pname}.love
    makeWrapper ${love}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love

    chmod +x $out/bin/${pname}
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "Create your own music";
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
    license = licenses.free;
    downloadPage = http://stabyourself.net/rimshot/;
  };

}
