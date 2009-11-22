# this package was called gimp-print in the past
{ fetchurl, stdenv, lib, pkgconfig, composableDerivation, cups
, libtiff, libpng, openssl, git, gimp }@args :

let
   version = "5.2.4";
   inherit (args.composableDerivation) composableDerivation edf wwf;
in
composableDerivation {} {
  name = "gutenprint-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gimp-print/files/gutenprint-5.2/${version}/gutenprint-${version}.tar.bz2";
    sha256 = "09lnmf92h51sm0hmzd1hn2kl1sh6dxlnc0zjd9lrifzg0miyh45n";
  };

  # gimp, gui is still not working (TODO)
  buildInputs = [ openssl  pkgconfig];

  configureFlags = ["--enable-static-genppd"];
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

  mergeAttrBy = { installArgs = lib.concat; };

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
