{ stdenv, fetchFromGitHub, skalibs, gcc }:

with stdenv.lib;
let
  cross = "";
in

stdenv.mkDerivation rec {
  name = "s6-portable-utils-${version}";
  version = "2.1.0.0";

  src = fetchFromGitHub {
    owner = "skarnet";
    repo = "s6-portable-utils";
    rev = "v${version}";
    sha256 = "0k5pcwc45jw5l8ycz03wx2w4pds0wp4ll47d3i5i1j02i9v0rhc9";
  };

  dontDisableStatic = true;
  
  nativeBuildInputs = []
    ++ optional stdenv.isDarwin gcc;
  
  configureFlags = [
    #"--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    #"--with-include=${skalibs}/include"
     "--with-lib=${skalibs}/lib"
     "--with-dynlib=${skalibs}/lib"
        ];
        
  
  meta = {
    homepage = http://www.skarnet.org/software/s6-portable-utils/;
    description = "A set of tiny general Unix utilities optimized for simplicity and small size";
    platforms = platforms.all;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
  };

}
