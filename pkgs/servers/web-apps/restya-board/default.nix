{ lib, stdenv, fetchurl, unzip }:

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
  pname = "rstya-board";
  version = "0.6";

  src = fetchurl {
    url = "https://github.com/RestyaPlatform/board/releases/download/v${version}/board-v${version}.zip";
    sha256 = "1js8c69qmga7bikp66fqhch3n2vw49918z32q88lz3havqzai8gd";
  };

  nativeBuildInputs = [ unzip ];

  buildCommand = ''
    mkdir $out
    unzip -d $out $src

    cd $out
    patch -p1 < ${./fix_request-uri.patch}

    chmod +x $out/server/php/shell/*.sh

    mkdir $out/client/apps
    unzip -d $out/client/apps ${hide-card-id}
    unzip -d $out/client/apps ${togetherjs}
  '';

  meta = with lib; {
    description = "Web-based kanban board";
    license = licenses.osl3;
    homepage = "https://restya.com";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}

