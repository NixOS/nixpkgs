{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "stun";
  version = "0.97";

  src = fetchurl {
    url    = "mirror://sourceforge/${pname}/stund-${version}.tgz";
    sha256 = "1mxirnnqfqdwb9x8hfjjsscp6lx3468ph6ddx32l94ir46fbzqc3";
  };

  srcManpages = fetchurl {
    url    = "mirror://ubuntu/pool/universe/s/stun/stun_0.97~dfsg-2.debian.tar.xz";
    name   = "stun-debian.tar.xz";
    sha256 = "1pr6zrdhia0aafsvywl1hrhlgl00vahp63bw1z2mzvdxri7q88f0";
  };

  outputs = [ "out" "server" ];

  preBuild = ''
    tar Jxvf ${srcManpages} debian/manpages
    gzip -9 debian/manpages/stun.1
    gzip -9 debian/manpages/stund.8
  '';

  installPhase = ''
    mkdir -p $out/bin $server/bin $out/man/man1 $server/man/man8
    cp -v client $out/bin/stun
    cp -v server $server/bin/stund
    cp -v debian/manpages/stun.1.gz  $out/man/man1
    cp -v debian/manpages/stund.8.gz $server/man/man8
  '';

  meta = with stdenv.lib; {
    description = "Stun server and test client";
    homepage    = http://sourceforge.net/projects/stun/;
    license     = licenses.vsl10;
    maintainers = with maintainers; [ marcweber obadz ];
    platforms   = platforms.linux;
  };
}
