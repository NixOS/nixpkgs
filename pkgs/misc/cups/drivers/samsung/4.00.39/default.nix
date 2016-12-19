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

{ stdenv, fetchurl, cups, gcc, ghostscript, glibc, patchelf }:

# Do not bump lightly! Visit <http://www.bchemnet.com/suldr/supported.html>
# to see what will break when upgrading. Consider a new versioned attribute.
let
  cups' = cups.out;
in stdenv.mkDerivation rec {
  name = "samsung-UnifiedLinuxDriver-${version}";
  version = "4.00.39";

  src = fetchurl {
    url = "http://www.bchemnet.com/suldr/driver/UnifiedLinuxDriver-${version}.tar.gz";
    sha256 = "144b4xggbzjfq7ga5nza7nra2cf6qn63z5ls7ba1jybkx1vm369k";
  };

  buildInputs = [ cups' gcc ghostscript glibc patchelf ];

  inherit gcc ghostscript glibc;
  cups = cups';

  builder = ./builder.sh;

  meta = with stdenv.lib; {
    description = "Samsung's Linux printing drivers; includes binaries without source code";
    homepage = http://www.samsung.com/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
