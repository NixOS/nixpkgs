{ stdenv, fetchurl, zlib }:

/* Cargo binary snapshot */

let snapshotDate = "2015-01-24";
in

with ((import ./common.nix) { inherit stdenv; version = "snapshot-${snapshotDate}"; });

let snapshotHash = if stdenv.system == "i686-linux"
      then "96213038f850569f1c4fa6a0d146c6155c0d566b"
      else if stdenv.system == "x86_64-linux"
      then "4d87486493c2881edced7b1d2f8beaac32aaa5b5"
      else if stdenv.system == "i686-darwin"
      then "17b9fc782e86bffe170abb83a01e0cb7c90a0daa"
      else if stdenv.system == "x86_64-darwin"
      then "18887bdbd3e6d2a127aa34216fa06e9877b0fbc6"
      else throw "no snapshot for platform ${stdenv.system}";
    snapshotName = "cargo-nightly-${platform}.tar.gz";
in


stdenv.mkDerivation {
  inherit name;
  inherit version;
  inherit meta;

  src = fetchurl {
    url = "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/${snapshotDate}/${snapshotName}";
    sha1 = snapshotHash;
  };

  dontStrip = true;

  installPhase = ''
    mkdir -p "$out"
    cp -r bin "$out/bin"
  '' + (if stdenv.isLinux then ''
    patchelf --interpreter "${stdenv.glibc}/lib/${stdenv.cc.dynamicLinker}" \
             --set-rpath "${stdenv.cc.gcc}/lib/:${stdenv.cc.gcc}/lib64/:${zlib}/lib" \
             "$out/bin/cargo"
  '' else "");
}
