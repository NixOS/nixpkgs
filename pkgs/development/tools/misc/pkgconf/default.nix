{ lib
, stdenv
, fetchurl
, removeReferencesTo
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pkgconf";
  version = "2.0.3";

  src = fetchurl {
    url = "https://distfiles.dereferenced.org/pkgconf/pkgconf-${finalAttrs.version}.tar.xz";
    hash = "sha256-yr3zxHRSmFT3zM6Fc8WsaK00p+YhA3U1y8OYH2sjg2w=";
  };

  outputs = [ "out" "lib" "dev" "man" "doc" ];

  nativeBuildInputs = [ removeReferencesTo ];

  enableParallelBuilding = true;

  # Debian has outputs like these too
  # (https://packages.debian.org/source/bullseye/pkgconf), so it is safe to
  # remove those references
  postFixup = ''
    remove-references-to \
      -t "${placeholder "out"}" \
      "${placeholder "lib"}"/lib/*
    remove-references-to \
      -t "${placeholder "dev"}" \
      "${placeholder "lib"}"/lib/* \
      "${placeholder "out"}"/bin/*
  ''
  # Move back share/aclocal. Yes, this normally goes in the dev output for good
  # reason, but in this case the dev output is for the `libpkgconf` library,
  # while the aclocal stuff is for the tool. The tool is already for use during
  # development, so there is no reason to have separate "dev-bin" and "dev-lib"
  # outputs or something.
  + ''
    mv ${placeholder "dev"}/share ${placeholder "out"}
  '';

  meta = {
    homepage = "https://github.com/pkgconf/pkgconf";
    description = "Package compiler and linker metadata toolkit";
    longDescription = ''
      pkgconf is a program which helps to configure compiler and linker flags
      for development libraries. It is similar to pkg-config from
      freedesktop.org.

      libpkgconf is a library which provides access to most of pkgconf's
      functionality, to allow other tooling such as compilers and IDEs to
      discover and use libraries configured by pkgconf.
    '';
    changelog = "https://github.com/pkgconf/pkgconf/blob/pkgconf-${finalAttrs.version}/NEWS";
    license = lib.licenses.isc;
    mainProgram = "pkgconf";
    maintainers = with lib.maintainers; [ zaninime AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
