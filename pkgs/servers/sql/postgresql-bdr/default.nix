{ stdenv, lib, fetchurl, postgresql, readline, openssl, zlib }:

stdenv.lib.overrideDerivation  postgresql (oldAttrs: rec {
  name = "postgresql-bdr-9.4.5";

  src = fetchurl {
    url = "http://packages.2ndquadrant.com/postgresql-bdr94-2ndquadrant/tarballs/postgresql-bdr-9.4.5_bdr1.tar.bz2";
    md5 = "1b43b8adf7f58d06d011d7e3488858c5";
  };

  bdr_src = fetchurl {
    url = "http://packages.2ndquadrant.com/postgresql-bdr94-2ndquadrant/tarballs/bdr-0.9.3.tar.bz2";
    md5 = "43689fd290be1ac80d9849832636500b";
  };

  postInstall = ''
    cd ..
    unpackFile ${bdr_src}
    cd bdr-0.9.3
    PATH=$out/bin:"$PATH" ./configure
    make -j4 -s all
    make -s install
    # make check

    # Prevent a retained dependency on gcc-wrapper.
    substituteInPlace $out/lib/pgxs/src/Makefile.global --replace ${stdenv.cc}/bin/ld ld
  '';

  doCheck = true;

  /*meta = with lib; {
    homepage = "http://2ndquadrant.com/en-us/resources/bdr/";
    description = "Multi-master logic replacation enabled postgresql variant.";
    license = licenses.postgresql;
  #  maintainers = [];
    lib.platforms = platforms.unix;
    lib.hydraPlatforms = platforms.linux;
  };*/
})
