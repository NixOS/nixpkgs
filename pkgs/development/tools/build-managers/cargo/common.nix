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
    then "4dea04e278192c5409f43794a98f20a8f59df2d9"
    else if stdenv.system == "x86_64-linux"
    then "3e48c573d3c4d26591feb7bfe988174720f08374"
    else if stdenv.system == "i686-darwin"
    then "dc3d498c0567af4a0820e91756dcfff8fde0efac"
    else if stdenv.system == "x86_64-darwin"
    then "f301bd8c3c93a5c88698c69190e464af1525ac96"
    else throw "no snapshot for platform ${stdenv.system}";

  snapshotDate = "2014-12-21";
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
      patchelf --interpreter "${stdenv.glibc}/lib/${stdenv.cc.dynamicLinker}" \
               --set-rpath "${stdenv.cc.gcc}/lib/:${stdenv.cc.gcc}/lib64/:${zlib}/lib" \
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
