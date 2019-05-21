{ stdenv
, fetchurl
, substituteAll
, gzip
, json_c
, libaio
, liburcu
, linuxHeaders
, lvm2
, perl
, pkg-config
, readline
, systemd
}:

stdenv.mkDerivation rec {
  name = "multipath-tools-${version}";
  version = "0.8.1";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://git.opensvc.com/?p=multipath-tools/.git;a=snapshot;h=${version};sf=tgz";
    sha256 = "14q620g0wdflzk1pajqv35zkq4j95rhki9h78q1m9kwmghyx8d6c";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit linuxHeaders lvm2;
      systemd = systemd.dev;
    })
  ];

  nativeBuildInputs = [ gzip perl pkg-config ];
  buildInputs = [ systemd lvm2 libaio readline liburcu json_c ];

  makeFlags = [
    "LIB=lib"
    "prefix=$(out)"
    "mandir=$(out)/share/man/man8"
    "man5dir=$(out)/share/man/man5"
    "man3dir=$(out)/share/man/man3"
    "unitdir=$(out)/lib/systemd/system"
  ];

  meta = with stdenv.lib; {
    description = "Tools for the Linux multipathing driver";
    homepage = http://christophe.varoqui.free.fr/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
