{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "bashmount-${version}";
  version = "3.2.0";

  src = fetchurl {
    url = "https://github/jamielinux/bashmount/archive/${version}.tar.gz";
    sha256 = "08ncksz8xl0qg5y5qf64b9adfnsg6769wf5bw8lv8q0zjbhjiwrj";
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
    homepage = https://github.com/jamielinux/bashmount;
    description = "A menu-driven bash script for the management of removable media with udisks";
    maintainers = maintainers.koral;
    platforms = platforms.all;
  };
}
