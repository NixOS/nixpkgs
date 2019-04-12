{ stdenv, fetchurl, mysql, mailutils, pbzip2, pigz, bzip2, gzip }:

stdenv.mkDerivation rec {
  pname = "automysqlbackup";
  version = "3.0_rc6";

  src = fetchurl {
    url = "mirror://sourceforge/automysqlbackup/AutoMySQLBackup/AutoMySQLBackup VER 3.0/automysqlbackup-v${version}.tar.gz";
    sha256 = "1h1wq86q6my1a682nr8pjagjhai4lxz967m17lhpw1vb116hd7l8";
  };

  sourceRoot = ".";

  postPatch = ''
    sed -e "s|PATH=.*$|PATH=\''${PATH}:${stdenv.lib.makeBinPath [ mysql mailutils pbzip2 pigz  bzip2 gzip ]}|" -i automysqlbackup
  '';

  installPhase = ''
    mkdir -p $out/bin $out/etc

    cp automysqlbackup $out/bin/
    cp automysqlbackup.conf $out/etc/
  '';
}
