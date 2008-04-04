{stdenv, fetchurl, tcl}:

stdenv.mkDerivation {
  name = "expect-5.43.0";
  
  src = fetchurl {
    url = http://expect.nist.gov/old/expect-5.43.0.tar.bz2;
    sha256 = "1j6vyr8lx1fbl641hkkd6hhh9ifniklskfv00pbvy33h86a3mrvn";
  };

  buildInputs = [tcl];

  #NIX_CFLAGS_COMPILE = "-DHAVE_UNISTD_H";

  # http://wiki.linuxfromscratch.org/lfs/ticket/2126
  #preBuild = ''
  #  substituteInPlace exp_inter.c --replace tcl.h tclInt.h
  #'';

  patchPhase = ''
    substituteInPlace configure --replace /bin/stty "$(type -tP stty)"
  '';
  
  configureFlags = "--with-tcl=${tcl}/lib --with-tclinclude=${tcl}/include";

  meta = {
    description = "A tool for automating interactive applications";
    homepage = http://expect.nist.gov/;
  };
}
