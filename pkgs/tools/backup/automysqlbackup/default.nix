{ stdenv, fetchurl, makeWrapper, mysql, mailutils, pbzip2, pigz, bzip2, gzip }:

stdenv.mkDerivation rec {
  pname = "automysqlbackup";
  version = "3.0_rc6";

  src = fetchurl {
    url = "mirror://sourceforge/automysqlbackup/AutoMySQLBackup/AutoMySQLBackup%20VER%203.0/automysqlbackup-v${version}.tar.gz";
    sha256 = "1h1wq86q6my1a682nr8pjagjhai4lxz967m17lhpw1vb116hd7l8";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/etc

    cp automysqlbackup $out/bin/
    cp automysqlbackup.conf $out/etc/

    wrapProgram $out/bin/automysqlbackup --prefix PATH : ${stdenv.lib.makeBinPath [ mysql mailutils pbzip2 pigz bzip2 gzip ]}
  '';

  meta = with stdenv.lib; {
    description = "A script to run daily, weekly and monthly backups for your MySQL database";
    homepage = https://sourceforge.net/projects/automysqlbackup/;
    platforms = platforms.linux;
    maintainers = [ maintainers.aanderse ];
    license = licenses.gpl2Plus;
  };
}
