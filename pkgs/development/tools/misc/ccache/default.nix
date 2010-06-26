{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ccache-3.0";
  src = fetchurl {
    url = http://samba.org/ftp/ccache/ccache-3.0.tar.gz;
    sha256 = "0mi8sfnlcp2pmp7nzb7894rv85v13zxrj0v3qgnwhny3gx2p5pgk";
  };

  meta = {
    description = "ccache, a tool that caches compilation results.";
    homepage = http://ccache.samba.org/;
    license = "GPL";
  };
}
