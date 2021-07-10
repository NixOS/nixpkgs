{ asciidoc, stdenv, gpgme, meson, python3, ninja, lib, fetchurl, pkg-config, m4, perl, libarchive, openssl, zlib, bzip2,
xz, curl, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "pacman";
  version = "6.0.0";

  src = fetchurl {
    url = "https://sources.archlinux.org/other/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0228bn8gk25hk816x80i064nnv2mnwgmvpd4l33vsivpb844hi00";
  };

  nativeBuildInputs = [ pkg-config meson ninja python3 ];
  buildInputs = [ asciidoc gpgme curl perl libarchive openssl zlib bzip2 xz ];

  enableParallelBuilding = true;

  mesonFlags = [
    "--sysconfdir=etc"
    "--localstatedir=var"
    "-Dscriptlet-shell=${runtimeShell}"
  ];

  installPhase = ''
    meson install
  '';

  postFixup = ''
    substituteInPlace $out/bin/repo-add \
      --replace bsdtar "${libarchive}/bin/bsdtar"
  '';

  meta = with lib; {
    description = "A simple library-based package manager";
    homepage = "https://www.archlinux.org/pacman/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mt-caret ];
  };
}
