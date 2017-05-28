{ fetchgit, stdenv }:

stdenv.mkDerivation rec {
  name = "kati-unstable-${version}";
  version = "2017-05-23";
  rev = "2dde61e46ab789f18956ff3b7c257dd8eb97993f";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/google/kati.git";
    sha256 = "1das1fvycra546lmh72cr5qpgblhbzqqy7gfywiijjgx160l75vq";
  };

  patches = [ ./version.patch ];

  installPhase = ''
    install -D ckati $out/bin/ckati
  '';

  meta = {
    description = "An experimental GNU make clone";
    homepage = "https://github.com/google/kati";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.asl20;
  };
}
