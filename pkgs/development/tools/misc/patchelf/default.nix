{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "patchelf-0.1pre1513";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/patchelf-0.1pre1513.tar.gz;
    md5 = "874928f46117828c1d8019986aa2eaac";
  };
#  src = /home/eelco/Dev/patchelf/patchelf-0.1.tar.gz;
}
