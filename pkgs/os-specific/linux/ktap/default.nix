{ stdenv, fetchgit, kernel, useFFI ? false }:

let
  ffiArgs = stdenv.lib.optionalString useFFI "FFI=1";
in
stdenv.mkDerivation rec {
  name = "ktap-${version}";
  version = "0.5-e7a38ef0";
  src = fetchgit {
    url    = "https://github.com/ktap/ktap.git";
    rev    = "e7a38ef06bec9a651c9e8bdb3ad66a104210d475";
    sha256 = "07acf20e1926d3afd89b13855154b8cc792c57261e7d3cae2da70cb08844f9c8";
  };

  buildPhase = ''
    make ${ffiArgs} KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
  '';

  installPhase = ''
    mkdir -p $out/sbin
    cp ktap $out/sbin
    make modules_install KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build INSTALL_MOD_PATH=$out
  '';

  meta = {
    description = "A lightweight script-based dynamic tracing tool for Linux.";
    homepage    = "http://www.ktap.org";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
