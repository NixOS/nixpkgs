{ stdenv, fetchurl, zlib }:

/* Cargo binary snapshot */

let snapshotDate = "2014-12-30";
in

with ((import ./common.nix) { inherit stdenv; version = "snapshot-${snapshotDate}"; });

let snapshotHash = if stdenv.system == "i686-linux"
      then "ab8bba0918d3d2ddbd7fd21f147e223dbf04cece"
      else if stdenv.system == "x86_64-linux"
      then "0efe0f7bcbcbeb5494affcc8a2207db448a08c45"
      else if stdenv.system == "i686-darwin"
      then "e5097005b0a27c186b8edee24982fd4c3ebba81e"
      else if stdenv.system == "x86_64-darwin"
      then "6c0bb776e5645fb93b67341b111c715f39b25511"
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
