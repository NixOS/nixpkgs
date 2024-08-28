{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  libiconv,
  libvorbis,
  libmad,
  libao,
  CoreServices,
  IOKit,
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
    libiconv
    libvorbis
    libmad
    libao
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    IOKit
  ];

  hardeningDisable = [ "format" ];

  patches = [
    # Fix build on macOS SDK < 12
    # https://github.com/cdrdao/cdrdao/pull/19
    (fetchpatch {
      url = "https://github.com/cdrdao/cdrdao/commit/105d72a61f510e3c47626476f9bbc9516f824ede.patch";
      hash = "sha256-NVIw59CSrc/HcslhfbYQNK/qSmD4QbfuV8hWYhWelX4=";
    })

    # Fix undefined behaviour caused by uninitialized variable
    # https://github.com/cdrdao/cdrdao/pull/21
    (fetchpatch {
      url = "https://github.com/cdrdao/cdrdao/commit/251a40ab42305c412674c7c2d391374d91e91c95.patch";
      hash = "sha256-+nGlWw5rgc5Ns2l+6fQ4Hp2LbhO4R/I95h9WGIh/Ebw=";
    })
  ];

  # we have glibc/include/linux as a symlink to the kernel headers,
  # and the magic '..' points to kernelheaders, and not back to the glibc/include
  postPatch = ''
    sed -i 's,linux/../,,g' dao/sg_err.h
  '';

  # Needed on gcc >= 6.
  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  meta = {
    description = "Tool for recording audio or data CD-Rs in disk-at-once (DAO) mode";
    homepage = "https://cdrdao.sourceforge.net/";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
})
