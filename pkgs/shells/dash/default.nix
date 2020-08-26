{ autoreconfHook, lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.11.1";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "048n1rbw3v1ffzsw5mkc6zzvvf1csq7pcri7jraaqag38vqq3j3k";
  };

  hardeningDisable = [ "format" ];

  # Temporary fix until a proper one is accepted upstream
  patches = lib.lists.optional stdenv.isDarwin ./0001-fix-dirent64-et-al-on-darwin.patch;
  nativeBuildInputs = lib.lists.optional stdenv.isDarwin autoreconfHook;

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
