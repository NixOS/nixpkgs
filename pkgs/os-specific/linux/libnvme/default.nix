{ fetchFromGitHub
, json_c
, lib
, meson
, ninja
, openssl
, perl
, pkg-config
, python3
, stdenv
, systemd
}:

stdenv.mkDerivation rec {
  pname = "libnvme";
  version = "1.2";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "libnvme";
    rev = "v${version}";
    sha256 = "sha256-U9Fj3OcBe32C0PKhI05eF/6jikHAvdyvXH16IY0rWxI=";
  };

  postPatch = ''
    patchShebangs meson-vcs-tag.sh
    chmod +x doc/kernel-doc-check
    patchShebangs doc/kernel-doc doc/kernel-doc-check doc/list-man-pages.sh
  '';

  nativeBuildInputs = [
    meson
    ninja
    perl # for kernel-doc
    pkg-config
  ];

  buildInputs = [
    json_c
    openssl
    python3
    systemd
  ];

  mesonFlags = [
    "-Ddocs=man"
    "-Ddocs-build=true"
  ];

  doCheck = true;

  meta = with lib; {
    description = "C Library for NVM Express on Linux";
    homepage = "https://github.com/linux-nvme/libnvme";
    maintainers = with maintainers; [ zseri ];
    license = with licenses; [ lgpl21Plus ];
    platforms = platforms.linux;
  };
}
