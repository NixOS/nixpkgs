{ stdenv, fetchurl, arts, kdelibs, libX11, libXext, libXt, perl, qt3, zlib }:

let

    versionNumber = "0.5.3";

in

stdenv.mkDerivation {

  name = "six-${versionNumber}";

  src = fetchurl {
    url = "http://six.retes.hu/download/six-${versionNumber}.tar.gz";
    sha256 = "0hialm0kxr11rp5z452whjmxp2vaqqj668d0dfs32fd10ggi8wj4";
  };

  meta = {
    description = "Six - A Hex playing program for KDE";
    homepage = http://six.retes.hu/;
    license = "GPLv2";
  };

  buildInputs = [ arts kdelibs libX11 libXext libXt perl qt3 zlib ];

  # Supress some warnings which are less useful to us when making packages.
  NIX_CFLAGS_COMPILE = "-Wno-conversion -Wno-parentheses";

  # Without "--x-libraries=", we get the error
  # "impure path `/usr/lib' used in link".
  configureFlags = "--x-libraries=";

  patches = [ ./gcc43-includes.patch ];
}
