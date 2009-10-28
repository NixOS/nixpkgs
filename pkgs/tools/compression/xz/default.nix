{stdenv, fetchurl, lib}:

stdenv.mkDerivation {
  name = "xz-4.999.9beta";
  
  src = fetchurl {
    url = http://tukaani.org/xz/xz-4.999.9beta.tar.bz2;
    sha256 = "0p51d9jng9vfh56idhjbc40n3ypapznwfb1npsvxh23n772140rk";
  };

  meta = {
    homepage = http://tukaani.org/xz/;
    description = "Successor of the LZMA Utils package";
    license = "GPL/LGPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
