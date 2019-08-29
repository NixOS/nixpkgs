{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "bashmount-${version}";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "jamielinux";
    repo = "bashmount";
    rev = version;
    sha256 = "0rki4s0jgz6vkywc6hcx9qa551r5bnjs7sw0rdh93k64l32kh644";
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
    maintainers = [ maintainers.koral ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
