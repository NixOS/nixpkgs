{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "bashmount";
  version = "4.2.5";

  src = fetchFromGitHub {
    owner = "jamielinux";
    repo = "bashmount";
    rev = version;
    sha256 = "1gvi2562vng887ba33s774lhhkacl8yl7d8b0yaxylzx0ap2y7l0";
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/jamielinux/bashmount";
    description = "A menu-driven bash script for the management of removable media with udisks";
    maintainers = [ maintainers.koral ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
