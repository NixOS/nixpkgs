{stdenv, fetchurl, zlib}:

with stdenv.lib;

rec {
  platform = if stdenv.system == "i686-linux"
    then "i686-unknown-linux-gnu"
    else if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else if stdenv.system == "i686-darwin"
    then "i686-apple-darwin"
    else if stdenv.system == "x86_64-darwin"
    then "x86_64-apple-darwin"
    else throw "no snapshot to boostrap for this platform (missing platform url suffix)";

  snapshotHash = if stdenv.system == "i686-linux"
    then "c92895421e6fa170dbd713e74334b8c3cf22b817"
    else if stdenv.system == "x86_64-linux"
    then "66ee4126f9e4820cd82e78181931f8ea365904de"
    else if stdenv.system == "i686-darwin"
    then "e2364b1f1ece338b9fc4c308c472fc2413bff04e"
    else if stdenv.system == "x86_64-darwin"
    then "09f92f06ab4f048acf71d83dc0426ff1509779a9"
    else throw "no snapshot for platform ${stdenv.system}";

  snapshotDate = "2014-09-19";
  snapshotName = "cargo-nightly-${platform}.tar.gz";

  snapshot = stdenv.mkDerivation {
    name = "cargo-snapshot-${snapshotDate}";
    src = fetchurl {
      url = "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/${snapshotDate}/${snapshotName}";
      sha1 = snapshotHash;
    };
    dontStrip = true;
    installPhase = ''
      mkdir -p "$out"
      cp -r bin "$out/bin"
    '' + (if stdenv.isLinux then ''
      patchelf --interpreter "${stdenv.glibc}/lib/${stdenv.gcc.dynamicLinker}" \
               --set-rpath "${stdenv.gcc.gcc}/lib/:${stdenv.gcc.gcc}/lib64/:${zlib}/lib" \
               "$out/bin/cargo"
    '' else "");
  };

  meta = {
    homepage = http://crates.io;
    description = "Downloads your Rust project's dependencies and builds your project";
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.linux;
  };
}
