{stdenv, fetchurl}:
  
stdenv.mkDerivation {
  name = "nmap-3.55";
  
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/nmap-3.55.tar.bz2;
    md5 = "88b5f010f43b0e2ee0c2cfb468796aa9";
  };
  
}
