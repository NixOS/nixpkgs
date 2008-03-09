{stdenv, fetchurl, kernel_ext3cowpatched }:

stdenv.mkDerivation {
  name = "ext3cow-tools";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://ext3cow.com/tools/ext3cow-tools.tgz;
    sha256 = "78f55b19c8eeaa7b8abde63c7d6547b1ac0421a46d826a8d41c049719a3081f2";
  };

  kernel = kernel_ext3cowpatched;
}


#note that ext3cow requires the ext3cow kernel patch !!!!
