{stdenv, version}:

{
  inherit version;

  platform = if stdenv.system == "i686-linux"
    then "i686-unknown-linux-gnu"
    else if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else if stdenv.system == "i686-darwin"
    then "i686-apple-darwin"
    else if stdenv.system == "x86_64-darwin"
    then "x86_64-apple-darwin"
    else throw "no snapshot to bootstrap for this platform (missing platform url suffix)";

  meta = with stdenv.lib; {
    homepage = http://crates.io;
    description = "Downloads your Rust project's dependencies and builds your project";
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.linux;
  };

  name = "cargo-${version}";
}
