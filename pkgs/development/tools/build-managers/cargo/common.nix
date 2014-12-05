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
    then "3204c8a38721199f69d2971db887d1dc71a63825"
    else if stdenv.system == "x86_64-linux"
    then "39ca0d02eac184bc764ff9c1f645ca361715c5c2"
    else if stdenv.system == "i686-darwin"
    then "ebc1836424c4b3ba49f9adef271c50d2a8e134c0"
    else if stdenv.system == "x86_64-darwin"
    then "a2045e95984b65eab4a704152566f8ab9a3be518"
    else throw "no snapshot for platform ${stdenv.system}";

  snapshotDate = "2014-11-22";
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
