{ stdenv, buildPackages, autoreconfHook, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.11.2";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "0pvdpm1cgfbc25ramn4305a0158yq031q1ain4dc972rnxl7vyq0";
  };

  hardeningDisable = [ "format" ];

  # Temporary fix until a proper one is accepted upstream
  patches = stdenv.lib.optional stdenv.isDarwin ./0001-fix-dirent64-et-al-on-darwin.patch;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin autoreconfHook;

  meta = with stdenv.lib; {
    homepage = "http://gondor.apana.org.au/~herbert/dash/";
    description = "A POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
    platforms = platforms.unix;
    license = with licenses; [ bsd3 gpl2 ];
  };

  passthru = {
    shellPath = "/bin/dash";
  };
}
