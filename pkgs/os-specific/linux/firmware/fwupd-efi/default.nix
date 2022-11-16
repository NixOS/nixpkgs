{ lib
, stdenv
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
  version = "1.3";

  src = fetchFromGitHub {
    owner = "fwupd";
    repo = pname;
    rev = version;
    hash = "sha256-GF2a4RW5H4ybaBe1CS1dQK7eradJ0pzNe77T5fQzhLc=";
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
