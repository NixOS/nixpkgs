{ stdenv, fetchFromBitbucket, ocaml, zlib, db, perl, camlp4 }:

stdenv.mkDerivation rec {
  name = "sks-${version}";
  version = "1.1.6";

  src = fetchFromBitbucket {
    owner = "skskeyserver";
    repo = "sks-keyserver";
    rev = "${version}";
    sha256 = "00q5ma5rvl10rkc6cdw8d69bddgrmvy0ckqj3hbisy65l4idj2zm";
  };

  # pkgs.db provides db_stat, not db$major.$minor_stat
  patches = [ ./adapt-to-nixos.patch ];

  outputs = [ "out" "webSamples" ];

  buildInputs = [ ocaml zlib db perl camlp4 ];

  makeFlags = [ "PREFIX=$(out)" "MANDIR=$(out)/share/man" ];
  preConfigure = ''
    cp Makefile.local.unused Makefile.local
    sed -i \
      -e "s:^LIBDB=.*$:LIBDB=-ldb:g" \
      Makefile.local
  '';

  preBuild = "make dep";

  doCheck = true;
  checkPhase = "./sks unit_test";

  # Copy the web examples for the NixOS module
  postInstall = "cp -R sampleWeb $webSamples";

  meta = with stdenv.lib; {
    description = "An easily deployable & decentralized OpenPGP keyserver";
    longDescription = ''
      SKS is an OpenPGP keyserver whose goal is to provide easy to deploy,
      decentralized, and highly reliable synchronization. That means that a key
      submitted to one SKS server will quickly be distributed to all key
      servers, and even wildly out-of-date servers, or servers that experience
      spotty connectivity, can fully synchronize with rest of the system.
    '';
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos fpletz ];
  };
}

