{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "pdnsd";
  version = "1.2.9a-par";

  src = fetchurl {
    url = "http://members.home.nl/p.a.rombouts/pdnsd/releases/pdnsd-${version}.tar.gz";
    sha256 = "0yragv5zk77a1hfkpnsh17vvsw8b14d6mzfng4bb7i58rb83an5v";
  };

  patches =
    # fix build with linux headers >= 5.13
    lib.optional stdenv.isLinux
      (fetchpatch {
        name = "fix-build-linux-headers-gte-5.13.patch";
        url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/net-dns/pdnsd/files/pdnsd-1.2.9a-linux-5.13_build_fix.patch?id=7ce35657f269c3b7016e8940ad36e59cf06e12a4";
        hash = "sha256-Sh/0ZyiQpDvFZOWE9OCQ9+ocXurjzJvrE4WNWaGwAwk=";
      });

  postPatch = ''
    sed -i 's/.*(cachedir).*/:/' Makefile.in
  '';

  configureFlags = [ "--enable-ipv6" ];

  # fix ipv6 on darwin
  CPPFLAGS = "-D__APPLE_USE_RFC_3542";

  meta = with lib; {
    description = "Permanent DNS caching";
    homepage = "http://members.home.nl/p.a.rombouts/pdnsd";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
