{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ccache-2.4";
  src = fetchurl {
    url = http://samba.org/ftp/ccache/ccache-2.4.tar.gz;
    sha256 = "435f862ca5168c346f5aa9e242174bbf19a5abcaeecfceeac2f194558827aaa0";
  };

  meta = {
    description = "ccache, a tool that caches compilation results.";
    homepage = http://ccache.samba.org/;
    license = "GPL";
  };
}
