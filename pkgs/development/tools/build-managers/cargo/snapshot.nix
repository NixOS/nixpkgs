{ stdenv, fetchurl, zlib, makeWrapper, rustc }:

/* Cargo binary snapshot */

let snapshotDate = "2016-01-31";
in

with ((import ./common.nix) {
  inherit stdenv rustc;
  version = "snapshot-${snapshotDate}";
});

let snapshotHash = if stdenv.system == "i686-linux"
      then "7e2f9c82e1af5aa43ef3ee2692b985a5f2398f0a"
      else if stdenv.system == "x86_64-linux"
      then "4c03a3fd2474133c7ad6d8bb5f6af9915ca5292a"
      else if stdenv.system == "i686-darwin"
      then "4d84d31449a5926f9e7ceb344540d6e5ea530b88"
      else if stdenv.system == "x86_64-darwin"
      then "f8baef5b0b3e6f9825be1f1709594695ac0f0abc"
      else throw "no snapshot for platform ${stdenv.system}";
    snapshotName = "cargo-nightly-${platform}.tar.gz";
in

stdenv.mkDerivation {
  inherit name version meta passthru;

  src = fetchurl {
    url = "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/${snapshotDate}/${snapshotName}";
    sha1 = snapshotHash;
  };

  buildInputs = [ makeWrapper ];

  dontStrip = true;

  __propagatedImpureHostDeps = [
    "/usr/lib/libiconv.2.dylib"
    "/usr/lib/libssl.0.9.8.dylib"
    "/usr/lib/libcurl.4.dylib"
    "/System/Library/Frameworks/GSS.framework/GSS"
    "/System/Library/Frameworks/GSS.framework/Versions/Current"
    "/System/Library/PrivateFrameworks/Heimdal.framework/Heimdal"
    "/System/Library/PrivateFrameworks/Heimdal.framework/Versions/Current"
  ];

  installPhase = ''
    mkdir -p "$out"
    ./install.sh "--prefix=$out"
  '' + (if stdenv.isLinux then ''
    patchelf --interpreter "${stdenv.glibc}/lib/${stdenv.cc.dynamicLinker}" \
             --set-rpath "${stdenv.cc.cc}/lib/:${stdenv.cc.cc}/lib64/:${zlib}/lib" \
             "$out/bin/cargo"
  '' else "") + postInstall;
}
