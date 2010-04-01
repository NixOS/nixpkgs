{stdenv, fetchurl, lib}:

stdenv.mkDerivation ({
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

//

(if stdenv.system == "x86_64-darwin"
 # Work around assembler misconfiguration as `x86'.  This appears to be fixed
 # by commit b9b5c54cd438b3ae47b44cc211b71f3bc53e35ef (Nov 22 12:00:30 2009 # +0200).
 then { configureFlags = "--enable-assembler=x86_64"; }
 else {}))
