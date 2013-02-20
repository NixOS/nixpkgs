{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cpio-2.9";
  
  src = fetchurl {
    url = mirror://gnu/cpio/cpio-2.11.tar.bz2;
    sha256 = "bb820bfd96e74fc6ce43104f06fe733178517e7f5d1cdee553773e8eff7d5bbd";
  };

  patches = [
    # Make it compile on GCC 4.3.
    (fetchurl {
      name = "cpio-2.9-gnu-inline.patch";
      url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/app-arch/cpio/files/cpio-2.9-gnu-inline.patch?rev=1.1";
      sha256 = "1167hrq64h9lh3qhgasm2rivfzkkgx6fik92b017qfa0q61ff8c3";
    })
  ];

  meta = {
    homepage = http://www.gnu.org/software/cpio/;
    description = "A program to create or extract from cpio archives";
  };
}
