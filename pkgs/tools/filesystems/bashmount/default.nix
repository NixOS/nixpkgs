{lib, stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "bashmount";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "jamielinux";
    repo = "bashmount";
    rev = version;
    sha256 = "1irw47s6i1qwxd20cymzlfw5sv579cw877l27j3p66qfhgadwxrl";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bashmount $out/bin

    mkdir -p $out/etc
    cp bashmount.conf $out/etc

    mkdir -p $out/share/man/man1
    gzip -c -9 bashmount.1 > bashmount.1.gz
    cp bashmount.1.gz $out/share/man/man1

    mkdir -p $out/share/doc/bashmount
    cp COPYING $out/share/doc/bashmount
    cp NEWS    $out/share/doc/bashmount
  '';

  meta = with lib; {
    homepage = "https://github.com/jamielinux/bashmount";
    description = "A menu-driven bash script for the management of removable media with udisks";
    mainProgram = "bashmount";
    maintainers = [ maintainers.koral ];
    license = licenses.gpl2Only;
    platforms = platforms.all;
  };
}
