{ stdenv, fetchurl, cmake, libxml2, libzip }:

let
  pn = "ebook-tools";
in

stdenv.mkDerivation rec {
  name = "${pn}-0.2.1";

  src = fetchurl {
    url = "mirror://sf/${pn}/${name}.tar.gz";
    sha256 = "0wgwdsd3jwwfg36jyr5j0wayqjli3ia80lxzk10byd4cmkywnhy2";
  };

  buildInputs = [ cmake libxml2 libzip ];

  meta = {
    homepage = "http://${pn}.sourceforge.net";
    description = "Tools and libs for dealing with various ebook file formats";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
