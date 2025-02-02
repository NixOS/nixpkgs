{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, meson
, ninja
, gnu-efi
, python3
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "fwupd-efi";
  version = "1.6";

  src = fetchurl {
    url = "https://github.com/fwupd/fwupd-efi/releases/download/${version}/fwupd-efi-${version}.tar.xz";
    hash = "sha256-r9CAWirQgafK/y71vABM46AUe1OAFejsqWY0FxaxJg4=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/fwupd/fwupd-efi/commit/26c6ec5c1e7765fb5dc6a4df511ab21ee6c6e67a.patch";
      revert = true;
      hash = "sha256-vTdYExd7OlrrZ/LhlEO1zcvpKzeT5OeOeosD8/LUkMg=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    python3Packages.pefile
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
    maintainers = with maintainers; [ ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
