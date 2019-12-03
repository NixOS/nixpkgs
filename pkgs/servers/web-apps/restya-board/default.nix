{ stdenv, fetchurl, unzip }:

let

  hide-card-id = fetchurl {
    url = "https://github.com/RestyaPlatform/board-apps/releases/download/v2/r_hide_card_id-v0.1.2.zip";
    sha256 = "1scm696rs8wx0z2y0g6r9vf01b0yay79azw8n785c6zdvrbqw7dp";
  };

  togetherjs = fetchurl {
    url = "https://github.com/RestyaPlatform/board-apps/releases/download/v2/r_togetherjs-v0.1.2.zip";
    sha256 = "1kms7z0ci15plwbs6nxvz15w0ym3in39msbncaj3cn0p72kvx5cm";
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
    unzip -d $out/client/apps ${hide-card-id}
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

