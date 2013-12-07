{ stdenv, fetchurl, zlib, enableStatic ? false,
sftpPath ? "/var/run/current-system/sw/libexec/sftp-server" }:

stdenv.mkDerivation rec {
  name = "dropbear-2013.60";

  src = fetchurl {
    url = "http://matt.ucc.asn.au/dropbear/releases/${name}.tar.bz2";
    sha256 = "1fw1hrcavfqjmsn34dhkrzh8w06yfqvfss2rkvvnxnad7d2m432c";
  };

  dontDisableStatic = enableStatic;

  configureFlags = stdenv.lib.optional enableStatic "LDFLAGS=-static";

  CFLAGS = "-DSFTPSERVER_PATH=\\\"${sftpPath}\\\"";

  # http://www.gnu.org/software/make/manual/html_node/Libraries_002fSearch.html
  preConfigure = ''
    makeFlags=VPATH=`cat $NIX_GCC/nix-support/orig-libc`/lib
  '';

  crossAttrs = {
    # This works for uclibc, at least.
    preConfigure = ''
      makeFlags=VPATH=`cat ${stdenv.gccCross}/nix-support/orig-libc`/lib
    '';
  };

  patches = [
    # Allow sessions to inherit the PATH from the parent dropbear.
    # Otherwise they only get the usual /bin:/usr/bin kind of PATH
    ./pass-path.patch

    # Bugfix
    # http://article.gmane.org/gmane.network.ssh.dropbear/1361
    ./proxycrash.patch
  ];

  buildInputs = [ zlib ];

  meta = {
    homepage = http://matt.ucc.asn.au/dropbear/dropbear.html;
    description = "An small footprint implementation of the SSH 2 protocol";
    license = "mit";
  };
}
