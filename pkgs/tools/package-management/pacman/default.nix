{ fetchpatch, fetchurl, lib, meson, ninja, stdenv, pkg-config, python3,
  asciidoc, bzip2, curl, gpgme, libarchive, openssl, runtimeShell, xz, zlib }:

stdenv.mkDerivation rec {
  pname = "pacman";
  version = "6.0.0";

  src = fetchurl {
    url = "https://sources.archlinux.org/other/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0228bn8gk25hk816x80i064nnv2mnwgmvpd4l33vsivpb844hi00";
  };

  patches = [
    (fetchpatch {
      name = "fix-404-download.patch";
      url = "https://gitlab.archlinux.org/pacman/pacman/-/commit/3401f9e142ac4c701cd98c52618cb13164f2146b.patch";
      sha256 = "0fd07xs6ii57nlcd3zdaajbm9flhd68b34l32nqmnnlixrr430di";
    })
    (fetchpatch {
      name = "fix-key-import-double-free.patch";
      url = "https://gitlab.archlinux.org/pacman/pacman/-/commit/542910d684191eb7f25ddc5d3d8fe3060028a267.patch";
      sha256 = "04mgrmg6a7s38830whhb0i4gkhi3p7b0v8yxzympsyg52hcxrla2";
    })
  ];

  nativeBuildInputs = [ asciidoc meson ninja pkg-config python3 ];
  buildInputs = [ bzip2 curl gpgme libarchive openssl xz zlib ];

  enableParallelBuilding = true;

  mesonFlags = [
    "--sysconfdir=etc"
    "--localstatedir=var"
    "-Dscriptlet-shell=${runtimeShell}"
  ];

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
