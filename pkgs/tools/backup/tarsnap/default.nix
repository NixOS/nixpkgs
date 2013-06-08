{ stdenv, fetchurl, openssl, zlib, e2fsprogs }:

stdenv.mkDerivation {
  name = "tarsnap-1.0.33";

  src = fetchurl {
    url = "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.33.tgz";
    sha256 = "0z8bmra3xms9vcgvkiy9fy1j97192z6w7n658j6zr5cniid8438c";
  };

  buildInputs = [ openssl zlib e2fsprogs ];

  meta = {
    description = "Online backups for the truly paranoid";
    homepage = "http://www.tarsnap.com/";
    maintainers = with stdenv.lib.maintainers; [roconnor];
  };
}
