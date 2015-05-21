{ stdenv, fetchurl, zlib }:

/* Cargo binary snapshot */

let snapshotDate = "2015-04-02";
in

with ((import ./common.nix) { inherit stdenv; version = "snapshot-${snapshotDate}"; });

let snapshotHash = if stdenv.system == "i686-linux"
      then "ba6c162680d5509d89ba2363d7cae2047f40c034"
      else if stdenv.system == "x86_64-linux"
      then "94f715c9a52809a639f2ce6f8b1d5215a0c272b5"
      else if stdenv.system == "i686-darwin"
      then "cf333f16f89bfd50e8ce461c6f81ca30d33f7f73"
      else if stdenv.system == "x86_64-darwin"
      then "1f7008a6ec860e2bc7580e71bdf320ac518ddeb8"
      else throw "no snapshot for platform ${stdenv.system}";
    snapshotName = "cargo-nightly-${platform}.tar.gz";
in

stdenv.mkDerivation {
  inherit name version meta;

  src = fetchurl {
    url = "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/${snapshotDate}/${snapshotName}";
    sha1 = snapshotHash;
  };

  dontStrip = true;

  installPhase = ''
    mkdir -p "$out"
    ./install.sh "--prefix=$out"

    ${postInstall}
  '' + (if stdenv.isLinux then ''
    patchelf --interpreter "${stdenv.glibc}/lib/${stdenv.cc.dynamicLinker}" \
             --set-rpath "${stdenv.cc.cc}/lib/:${stdenv.cc.cc}/lib64/:${zlib}/lib" \
             "$out/bin/cargo"
  '' else "");
}
