# Tested on linux-x86_64.  Might work on linux-i386.  Probably won't work on anything else.

# To use this driver in NixOS, add it to printing.drivers in configuration.nix.
# configuration.nix might look like this when you're done:
# { pkgs, ... }: {
#   printing = {
#     enable = true;
#     drivers = [ pkgs.samsungUnifiedLinuxDriver ];
#   };
#   (more stuff)
# }
# (This advice was tested on 2010 August 2.)

{stdenv, fetchurl, cups, gcc, ghostscript, glibc, patchelf}:

stdenv.mkDerivation rec {
  name = "samsung-UnifiedLinuxDriver-0.92";

  src = fetchurl {
    url = "http://downloadcenter.samsung.com/content/DR/200911/20091103171827750/UnifiedLinuxDriver_0.92.tar.gz";
    sha256 = "0p2am0p8xvm339mad07c4j77gz31m63z76sy6d9hgwmxy2prbqfq";
  };

  buildInputs = [ cups gcc ghostscript glibc patchelf ];

  inherit cups gcc ghostscript glibc;

  builder = ./builder.sh;

  meta = {
    description = "Samsung's Linux drivers; includes binaries without source code";
    homepage = "http://www.samsung.com/";
    license = "samsung";  # Binary-only
  };
}
