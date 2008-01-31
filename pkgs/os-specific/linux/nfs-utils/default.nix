args: with args;
stdenv.mkDerivation {
  name = "nfs-utils-1.1.1";

  src = fetchurl {
    url = mirror://sourceforge/nfs/nfs-utils-1.1.1.tar.gz;
    sha256 = "0aa434cv7lgbrhks0rzhwxvbk2zsa17kjwxqjrrh87zrv9d2sr1x";
  };

  buildInputs = [kernelHeaders tcp_wrapper];

  meta = { 
      description = "nfs utils";
      homepage = http://nfs.sourceforge.net/;
      license = "GPL2";
  };
}
