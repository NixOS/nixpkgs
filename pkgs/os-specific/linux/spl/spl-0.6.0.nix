{ stdenv, fetchgit, kernel, linuxHeaders, perl }:

stdenv.mkDerivation {
  name = "spl-0.6.0-rc4";
  src = fetchgit {
    url = git://github.com/behlendorf/spl.git;
    rev = "dde6b7b137f56894a457";
    sha256 = "c402517a647de0c22a69588219aa214f96d1cf9d2f8751b99c5a2795898c726b";
  };

  patches = [ ./install_prefix.patch ./module_prefix.patch ];

  buildInputs = [ perl kernel linuxHeaders ];

  configureFlags = [ "--with-linux=${kernel}/lib/modules/${kernel.version}/build" 
                     "--with-linux-obj=${kernel}/lib/modules/${kernel.version}/build" ];

  meta = {
    description = "Kernel module driver for solaris porting layer (needed by in-kernel zfs)";
    homepage = http://zfsonlinux.org/;
    license = "CDDL";
    platforms = stdenv.lib.platforms.linux;
  };
}
