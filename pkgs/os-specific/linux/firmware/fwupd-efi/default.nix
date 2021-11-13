{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, substituteAll
, pkg-config
, meson
, ninja
, gnu-efi
, python3
}:

stdenv.mkDerivation rec {
  pname = "fwupd-efi";
  version = "1.1";

  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/${pname}-${version}.tar.xz";
    sha256 = "1w879qxlnsaz5xyp168a08f2p8yrgfpkfycls28jw8qxmz6g20aw";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    gnu-efi
  ];

  postPatch = ''
    patchShebangs \
      efi/generate_binary.py \
      efi/generate_sbat.py
  '';

  mesonFlags = [
    "-Defi-includedir=${gnu-efi}/include/efi"
    "-Defi-libdir=${gnu-efi}/lib"
    "-Defi-ldsdir=${gnu-efi}/lib"
    "-Defi_sbat_distro_id=nixos"
    "-Defi_sbat_distro_summary=NixOS"
    "-Defi_sbat_distro_pkgname=${pname}"
    "-Defi_sbat_distro_version=${version}"
    "-Defi_sbat_distro_url=https://search.nixos.org/packages?channel=unstable&show=fwupd-efi&from=0&size=50&sort=relevance&query=fwupd-efi"
  ];

  meta = with lib; {
    homepage = "https://fwupd.org/";
    maintainers = with maintainers; [ maxeaubrey ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
