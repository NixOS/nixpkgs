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
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "fwupd-efi";
  version = "1.5";

  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-RdKneTGzYkFt7CY22r9O/w0doQvBzMoayYDoMv7buhI=";
  };

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
    maintainers = with maintainers; [ amaxine ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
