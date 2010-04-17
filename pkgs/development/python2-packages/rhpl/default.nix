{stdenv, fetchurl, rpm, cpio, python, wirelesstools, gettext}:

stdenv.mkDerivation {
  name = "rhpl-0.218";
  
  src = fetchurl {
    url = http://ftp.stw-bonn.de/pub/fedora/linux/releases/10/Everything/source/SRPMS/rhpl-0.218-1.src.rpm;
    md5 = "a72c6b66df782ca1d4950959d2aad292";
  };
  
  inherit python;
  
  builder = ./builder.sh;
  
  buildInputs = [ rpm cpio python wirelesstools gettext ];
}
