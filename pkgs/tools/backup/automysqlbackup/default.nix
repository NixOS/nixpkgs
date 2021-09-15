{ lib, stdenv, fetchFromGitHub, makeWrapper, mariadb, mailutils, pbzip2, pigz, bzip2, gzip }:

stdenv.mkDerivation rec {
  pname = "automysqlbackup";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "sixhop";
    repo = pname;
    rev = version;
    sha256 = "0lki2049npc38r8m08garymywp1rzgflm0mxsfdznn9jfp4pk2lp";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/etc

    cp automysqlbackup $out/bin/
    cp automysqlbackup.conf $out/etc/

    wrapProgram $out/bin/automysqlbackup --prefix PATH : ${lib.makeBinPath [ mariadb mailutils pbzip2 pigz bzip2 gzip ]}
  '';

  meta = with lib; {
    description = "A script to run daily, weekly and monthly backups for your MySQL database";
    homepage = "https://github.com/sixhop/AutoMySQLBackup";
    platforms = platforms.linux;
    maintainers = [ maintainers.aanderse ];
    license = licenses.gpl2Plus;
  };
}
