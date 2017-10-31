{ fetchurl }:
rec {
  version = "3.2.10";

  libvsl = fetchurl {
    name = "fusionio-libvsl-${version}.deb";
    url = "https://drive.google.com/uc?export=download&id=0B7U0_ZBLoB2Wc01uNk1nVURMVFk";
    sha256 = "1i8ii9dlyskj2dvad7nfvlm1wz2s4gy5llbl29hfa13w6nhcl5wk";
  };

  util = fetchurl {
    name = "fusionio-util-${version}.deb";
    url = "https://drive.google.com/uc?export=download&id=0B7U0_ZBLoB2WbDVuQkwzWjZONGs";
    sha256 = "0aw64kk5cwchjhqh5n1lpqrrh5gn4qdalnmasd25z7sijy2flxgq";
  };

  vsl = fetchurl {
    name = "fusionio-iomemory-vsl-${version}.tar.gz";
    url = "https://drive.google.com/uc?export=download&id=0B7U0_ZBLoB2WbXFMbExEMUFCcWM";
    sha256 = "1zm20aa1jmmqcqkb4p9r4jsgbg371zr1abdz32rw02i9687fsgcc";
  };
}
