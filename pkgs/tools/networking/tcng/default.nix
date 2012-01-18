{ stdenv, fetchurl, bison, flex, db4, perl, kernel, iproute }:

# tcc can even compile kernel modules for speed reason.
# that would be a nice use case to test!

# something is still wrong. The output can't be pasred sometimes
# Eg it contains continue/pass,drop/pass, drop/drop. I've replaced
# them by ok, drop, drop using sed. I'm not sure wether this is the correct way
# Man pages are missing as well. So use the link at the bottom

let version = "10b"; in

stdenv.mkDerivation {

  name = "tcng-${version}";

  src = fetchurl {
    url = mirror://debian/pool/main/t/tcng/tcng_10b.orig.tar.gz;
    sha256 = "1xjs0yn90rfa8ibxybg3gab1xzcjg60njymq2bd1b0a9i0arx7ji";
  };

  iproute2Src = iproute.src;

  patches =
    [ (fetchurl {
        url = mirror://debian/pool/main/t/tcng/tcng_10b-2.diff.gz;
        sha256 = "17i4s2ffif0k4b78gfhkp08lvvharbfvyhwbd0vkwgpria0b9zrd";
      })
    ];
  
  # one mailinglist post says you should just add your kernel version to the list.. (?)
  patchPhase = ''
    unset patchPhase
    patchPhase
    unpackFile $iproute2Src
    IPROUTESRC=$(echo iproute*)
    for script in $(find . -type f); do sed -e 's@#![ ]*/bin/bash@#! /bin/sh@' -i $script; done
    find . -type f | xargs sed -i 's@/usr/bin/perl@${perl}/bin/perl@g'
    find . -type f | xargs sed -i 's@/lib/cpp@cpp@g'
  '';

  # gentoo ebulid says tcsim doesn't compile with 2.6 headers..
  # DATADIR can still be overridden by env TOPDIR=...
  # Don't know whats it for except including the default .tc files
  configurePhase=''
    cat >> config << EOF
    YACC="yacc"
    DATA_DIR="$out/lib/tcng"
    EOF
    ./configure \
    --kernel ${kernel}/lib/modules/2.6.28.6-default/build \
    --iproute2 $IPROUTESRC \
    --install-directory $out \
    --no-manual \
    --with-tcsim
  '';

  # hacky, how to enable building tcc the correct way?
  # adding shared and tcc to SUBDIRS and run make again isn't nice but works
  buildPhase = ''
    sed -i 's@^\(SUBDIRS.*\)@\1 shared tcc@' Makefile 
    make
  '';

  # manually copy tcc and include files.. see comment above
  installPhase = ''
    mkdir -p $out{,/sbin,/lib/tcng/include}
    make DESTDIR=$out install
    cp tcc/tcc $out/sbin
    cp tcc/*.tc $out/lib/tcng/include
  '';

  buildInputs = [ bison flex db4 perl ];

  meta = { 
    description = "tcng - Traffic Control Next Generation";
    homepage = "http://tcng.sourceforge.net/";
    license = "GPLv2";
  };
}
