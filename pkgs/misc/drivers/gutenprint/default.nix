# this package was called gimp-print in the past
{ fetchurl, stdenv, pkgconfig, composableDerivation, cups
, libtiff, libpng, openssl, gimp }:

let
   version = "5.2.7";
   inherit (composableDerivation) edf wwf;
in

composableDerivation.composableDerivation {} {
  name = "gutenprint-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gimp-print/gutenprint-${version}.tar.bz2";
    sha256 = "1lgf7d9vsszv0bzgsd8j3x5smby1lpk07d8x7isv1sz34y98jk0i";
  };

  # gimp, gui is still not working (TODO)
  buildInputs = [ openssl pkgconfig ];

  configureFlags = ["--enable-static-genppd"];
  NIX_CFLAGS_COMPILE="-include stdio.h";
  
  #preConfigure = ''
  #  configureFlags="--with-cups=$out/usr-cups $configureFlags"
  #'';
  
  /*
     is this recommended? without it this warning is printed:

            ***WARNING: Use of --disable-static-genppd or --disable-static
                        when building CUPS is very dangerous.  The build may
                        fail when building the PPD files, or may *SILENTLY*
                        build incorrect PPD files or cause other problems.
                        Please review the README and release notes carefully!
  */

  installPhase = ''
    eval "make install $installArgs"
  '';

  meta = { 
    description = "Ghostscript and cups printer drivers";
    homepage = http://sourceforge.net/projects/gimp-print/;
    license = "GPL";
  };

  mergeAttrBy = { installArgs = stdenv.lib.concat; };

  # most interpreters aren't tested yet.. (see python for example how to do it)
  flags =
      wwf {
        name = "gimp2";
        enable = {
          buildInputs = [gimp gimp.gtk];
          installArgs = [ "gimp2_plug_indir=$out/${gimp.name}-plugins" ];
        };
      }
      // {
        cups = {
          set = {
           buildInputs = [cups libtiff libpng ];
           installArgs = [ "cups_conf_datadir=$out cups_conf_serverbin=$out cups_conf_serverroot=$out"];
          };
        };
      }
    ;

  cfg = {
    gimp2Support = true;
    cupsSupport = true;
  };

}
