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
  name = "restya-board-${version}";
  version = "0.6.6";

  src = fetchurl {
    url = "https://github.com/RestyaPlatform/board/releases/download/v${version}/board-v${version}.zip";
    sha256 = "0qx0bsl99hyag8n4kvv3rcs103gwc0ibnyn5sa4m1fvasg7zhpi3";
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
    license = licenses.osl3;
    homepage = http://restya.com;
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
  };
}

