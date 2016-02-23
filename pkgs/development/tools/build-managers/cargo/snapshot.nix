{ stdenv, fetchurl, zlib, makeWrapper, rustc }:

/* Cargo binary snapshot */

let snapshotDate = "2015-06-17";
in

with ((import ./common.nix) {
  inherit stdenv rustc;
  version = "snapshot-${snapshotDate}";
});

let snapshotHash = if stdenv.system == "i686-linux"
      then "g2h9l35123r72hqdwayd9h79kspfb4y9"
      else if stdenv.system == "x86_64-linux"
      then "fnx2rf1j8zvrplcc7xzf89czn0hf3397"
      else if stdenv.system == "i686-darwin"
      then "3viz3fi2jx18qjwrc90nfhm9cik59my6"
      else if stdenv.system == "x86_64-darwin"
      then "h2bf3db4vwz5cjjkn98lxayivdc6dflp"
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
