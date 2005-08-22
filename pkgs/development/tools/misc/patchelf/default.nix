{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.1pre2286";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/patchelf-0.1pre2286/patchelf-0.1pre2286.tar.gz;
    md5 = "2b1377e6745c239255b3f4a6ba6c0c87";
  };
}
