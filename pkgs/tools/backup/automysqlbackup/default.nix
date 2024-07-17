{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  mariadb,
  mailutils,
  pbzip2,
  pigz,
  bzip2,
  gzip,
}:

stdenv.mkDerivation rec {
  pname = "automysqlbackup";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "sixhop";
    repo = pname;
    rev = version;
    sha256 = "sha256-C0p1AY4yIxybQ6a/HsE3ZTHumtvQw5kKM51Ap+Se0ZI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/etc

    cp automysqlbackup $out/bin/
    cp automysqlbackup.conf $out/etc/

    wrapProgram $out/bin/automysqlbackup --prefix PATH : ${
      lib.makeBinPath [
        mariadb
        mailutils
        pbzip2
        pigz
        bzip2
        gzip
      ]
    }
  '';

  meta = with lib; {
    description = "A script to run daily, weekly and monthly backups for your MySQL database";
    mainProgram = "automysqlbackup";
    homepage = "https://github.com/sixhop/AutoMySQLBackup";
    platforms = platforms.linux;
    maintainers = [ maintainers.aanderse ];
    license = licenses.gpl2Plus;
  };
}
