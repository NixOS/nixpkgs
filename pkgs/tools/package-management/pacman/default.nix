{ stdenv, lib, fetchurl, pkg-config, libarchive, openssl, bash,
curl, runtimeShell, meson, python3, gpgme, asciidoc, coreutils, ninja, perl}:

stdenv.mkDerivation rec {
  pname = "pacman";
  version = "6.0.1";

  src = fetchurl {
    url = "https://sources.archlinux.org/other/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-DbYUVuVqpJ4mDokcCwJb4hAxnmKxVSHynT6TsA079zE=";
  };

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace doc/meson.build --replace "/bin/true" "${coreutils}/bin/true"
    sed -i '/add_install_script.*mkdir.*DESTDIR/d' meson.build
  '';

  mesonFlags = ["-Dsysconfdir=${placeholder "out"}/etc" "-Dscriptlet-shell=${bash}/bin/bash"];

  nativeBuildInputs = [ pkg-config meson python3 asciidoc ninja ];
  buildInputs = [ curl libarchive openssl gpgme perl ];

  postFixup = ''
    substituteInPlace $out/bin/repo-add \
      --replace bsdtar "${libarchive}/bin/bsdtar"
    patchShebangs $out/share/makepkg/* $out/bin/makepkg
  '';

  meta = with lib; {
    description = "A simple library-based package manager";
    homepage = "https://www.archlinux.org/pacman/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mt-caret ];
  };
}
