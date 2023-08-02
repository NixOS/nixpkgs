{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libvorbis,
  libmad,
  libao,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdrdao";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/cdrdao/cdrdao-${finalAttrs.version}.tar.bz2";
    hash = "sha256-0ZtnyFPF26JAavqrbNeI53817r5jTKxGeVKEd8e+AbY=";
  };

  makeFlags = [ "RM=rm" "LN=ln" "MV=mv" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libvorbis
    libmad
    libao
  ];

  hardeningDisable = [ "format" ];

  # we have glibc/include/linux as a symlink to the kernel headers,
  # and the magic '..' points to kernelheaders, and not back to the glibc/include
  postPatch = ''
    sed -i 's,linux/../,,g' dao/sg_err.h
  '';

  # Needed on gcc >= 6.
  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  meta = {
    description = "A tool for recording audio or data CD-Rs in disk-at-once (DAO) mode";
    homepage = "https://cdrdao.sourceforge.net/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
  };
})
