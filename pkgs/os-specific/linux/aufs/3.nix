{ stdenv, kernel, perl }:

let

  aufsPredicate = x:
    if x ? features then
      (if x.features ? aufs3 then x.features.aufs3 else false)
    else false;
  featureAbort = abort "This kernel does not have aufs 3 support";
  patch = stdenv.lib.findFirst aufsPredicate featureAbort kernel.kernelPatches;

in

stdenv.mkDerivation {
  name = "aufs3-${patch.version}-${kernel.version}";

  src = patch.patch.src;

  buildInputs = [ perl ];

  makeFlags = "KDIR=${kernel}/lib/modules/${kernel.modDirVersion}/build";

  installPhase =
    ''
      mkdir -p $out/lib/modules/${kernel.modDirVersion}/misc
      cp -v aufs.ko $out/lib/modules/${kernel.modDirVersion}/misc

      # Install the headers because aufs3-util requires them.
      mkdir -p $out/include/linux
      cp -v usr/include/linux/aufs_type.h $out/include/linux
    '';

  passthru = { inherit patch; };
  meta = {
    description = "Another Unionfs implementation for Linux (third generation)";
    homepage = http://aufs.sourceforge.net/;
    maintainers = [ stdenv.lib.maintainers.eelco
                    stdenv.lib.maintainers.raskin
                    stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.linux;
  };
}
