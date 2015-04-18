{ stdenv, fetchurl, zlib }:

/* Cargo binary snapshot */

let snapshotDate = "2015-02-26";
in

with ((import ./common.nix) { inherit stdenv; version = "snapshot-${snapshotDate}"; });

let snapshotHash = if stdenv.system == "i686-linux"
      then "2a28b604d09b4a76a54a05d91f7f158692427b3a"
      else if stdenv.system == "x86_64-linux"
      then "7367f4aca86d38e209ef7236b00175df036c03e2"
      else if stdenv.system == "i686-darwin"
      then "e5cabb0a4a2b4e47f7b1ae9b802e2b5d0b14eac5"
      else if stdenv.system == "x86_64-darwin"
      then "3026c60ddd46d2bcf1cb178fc801095dbfba5286"
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
    ./install.sh "--prefix=$out"
  '' + (if stdenv.isLinux then ''
    patchelf --interpreter "${stdenv.glibc}/lib/${stdenv.cc.dynamicLinker}" \
             --set-rpath "${stdenv.cc.cc}/lib/:${stdenv.cc.cc}/lib64/:${zlib}/lib" \
             "$out/bin/cargo"
  '' else "");
}
