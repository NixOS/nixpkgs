{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cksfv-1.3.13";
  
  src = fetchurl {
    url = http://zakalwe.fi/~shd/foss/cksfv/files/cksfv-1.3.13.tar.bz2;
    sha256 = "0d8lipfdwcs31qql3qhqvgd2c6jhdlfnhdsyw84kka781ay1pvhn";
  };

  meta = {
    homepage = http://zakalwe.fi/~shd/foss/cksfv/;
    description = "A tool for verifying files against a SFV checksum file";
  };
}
