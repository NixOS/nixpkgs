{
  lib,
  stdenv,
  fetchFromGitHub,
  ocamlPackages,
  perl,
  zlib,
  db,
}:

let
  inherit (ocamlPackages)
    ocaml
    findlib
    cryptokit
    num
    ;
in

stdenv.mkDerivation rec {
  pname = "sks";
  version = "unstable-2021-02-04";

  src = fetchFromGitHub {
    owner = "SKS-Keyserver";
    repo = "sks-keyserver";
    rev = "c3ba6d5abb525dcb84745245631c410c11c07ec1";
    sha256 = "0fql07sc69hv6jy7x5svb19977cdsz0p1j8wv53k045a6v7rw1jw";
  };

  # pkgs.db provides db_stat, not db$major.$minor_stat
  patches = [
    ./adapt-to-nixos.patch
  ];

  outputs = [
    "out"
    "webSamples"
  ];

  nativeBuildInputs = [
    ocaml
    findlib
    perl
  ];
  buildInputs = [
    zlib
    db
    cryptokit
    num
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(out)/share/man"
  ];
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

  meta = with lib; {
    description = "An easily deployable & decentralized OpenPGP keyserver";
    longDescription = ''
      SKS is an OpenPGP keyserver whose goal is to provide easy to deploy,
      decentralized, and highly reliable synchronization. That means that a key
      submitted to one SKS server will quickly be distributed to all key
      servers, and even wildly out-of-date servers, or servers that experience
      spotty connectivity, can fully synchronize with rest of the system.
    '';
    inherit (src.meta) homepage;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
