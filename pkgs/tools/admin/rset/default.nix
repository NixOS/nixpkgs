{ lib, stdenv, fetchurl, coreutils, openssh, gnutar }:

stdenv.mkDerivation rec {
  pname = "rset";
  version = "2.1";

  src = fetchurl {
    url = "https://scriptedconfiguration.org/code/${pname}-${version}.tar.gz";
    sha256 = "0916f96afl8kcn2hpj4qhg92g2j93ycp2sb94nsz3q44sqc6ddhb";
  };

  patches = [ ./paths.patch ];

  postPatch = ''
    substituteInPlace rset.c \
      --replace @ssh@       ${openssh}/bin/ssh \
      --replace @miniquark@ $out/bin/miniquark \
      --replace @rinstall@  $out/bin/rinstall \
      --replace @rsub@      $out/bin/rsub

    substituteInPlace execute.c \
      --replace @ssh@     ${openssh}/bin/ssh \
      --replace @ssh-add@ ${openssh}/bin/ssh-add \
      --replace @tar@     ${gnutar}/bin/tar

    substituteInPlace rutils.c \
      --replace @install@ ${coreutils}/bin/install
  '';

  # these are to be run on the remote host,
  # so we want to preserve the original shebang.
  postFixup = ''
    sed -i "1s@.*@#!/bin/sh@" $out/bin/rinstall
    sed -i "1s@.*@#!/bin/sh@" $out/bin/rsub
  '';

  dontAddPrefix = true;
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://scriptedconfiguration.org/";
    description = "Configure systems using any scripting language";
    changelog = "https://github.com/eradman/rset/raw/${version}/NEWS";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
