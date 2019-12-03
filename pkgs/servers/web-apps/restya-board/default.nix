{ stdenv, fetchurl, unzip }:

let

  hide-card-additional-information = fetchurl {
    url = "https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_hide_card_additional_informations-v0.1.3.zip";
    sha256 = "1cp92av7b4nzdgybbqnh9jpkqkjv1rvm98ca96ib4qfsyi9gjrp7";
  };

  togetherjs = fetchurl {
    url = "https://github.com/RestyaPlatform/board-apps/releases/download/v1/r_togetherjs-v0.1.3.zip";
    sha256 = "1p765kbx4wzf6grgy4x3kvczm6jkm1ipl0cvkvyg4dsim07ab0zy";
  };

in

stdenv.mkDerivation rec {
  pname = "restya-board";
  version = "0.6.7";

  src = fetchurl {
    url = "https://github.com/RestyaPlatform/board/releases/download/v${version}/board-v${version}.zip";
    sha256 = "07xiakk8fljc79qi80n5945hy2rqrc8kn2i7d49rri2f440wv51i";
  };

  nativeBuildInputs = [ unzip ];

  buildCommand = ''
    mkdir $out
    unzip -d $out $src

    cd $out

    chmod +x $out/server/php/shell/*.sh

    mkdir $out/client/apps
    unzip -d $out/client/apps ${hide-card-additional-information}
    unzip -d $out/client/apps ${togetherjs}
  '';

  meta = with stdenv.lib; {
    description = "Web-based kanban board";
    longDescription = ''
      An open Source Trello-like Kanban-Board based on the Restya platform.
      Please note: When updating this software, you have to run the database
      migration scripts manually. You can find them at in the source repository
      under /sql. More detailed instructions can be found at
      https://github.com/RestyaPlatform/board/tree/v0.6.7#upgrade
    '';
    license = licenses.osl3;
    homepage = http://restya.com;
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
  };
}

