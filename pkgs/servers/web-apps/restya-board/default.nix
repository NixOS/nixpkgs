{ stdenv, fetchurl, fetchFromGitHub }:

let

  board-apps = fetchFromGitHub {
    owner = "RestyaPlatform";
    repo = "board-apps";
    rev = "v1";
    sha256 = "038qq0x547xzr9v1sa6cd3pagi2z4sfy80lcjn3qqgp5h39mb02x";
  };

in

stdenv.mkDerivation rec {
  pname = "restya-board";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "RestyaPlatform";
    repo = "board";
    rev = "v${version}";
    sha256 = "0vba8qrg28a5g2ax7xzdp5j2wgl4v7cgasbzhhdji29qjfrldgbf";
  };

  nativeBuildInputs = [ ];

  outputs = [ "out" ];

  buildCommand = ''
    mkdir $out
    mkdir -p $out/client/apps
    cp -r $src/* $out

    cd $out

    chmod +x $out/server/php/shell/*.sh

    cp -r ${board-apps}/r_hide_card_id $out/client/apps
    cp -r ${board-apps}/r_togetherjs $out/client/apps
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

