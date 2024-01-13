{ fetchFromGitHub
, json_c
, keyutils
, lib
, meson
, ninja
, openssl
, perl
, pkg-config
, python3
, stdenv
, swig
, systemd
# ImportError: cannot import name 'mlog' from 'mesonbuild'
, withDocs ? stdenv.hostPlatform.canExecute stdenv.buildPlatform
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnvme";
  version = "1.7.1";

  outputs = [ "out" ] ++ lib.optionals withDocs [ "man" ];

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "libnvme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hCR/K8bPXj8HthayrnwwGfI+wxpUwcWkcx3S/8h+3m8=";
  };

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [
    meson
    ninja
    perl # for kernel-doc
    pkg-config
    python3.pythonOnBuildForHost
    swig
  ];

  buildInputs = [
    keyutils
    json_c
    openssl
    systemd
    python3
  ];

  mesonFlags = [
    "-Ddocs=man"
    (lib.mesonBool "tests" finalAttrs.finalPackage.doCheck)
    (lib.mesonBool "docs-build" withDocs)
  ];

  preConfigure = ''
    export KBUILD_BUILD_TIMESTAMP="$(date -u -d @$SOURCE_DATE_EPOCH)"
  '';

  # mocked ioctl conflicts with the musl one: https://github.com/NixOS/nixpkgs/pull/263768#issuecomment-1782877974
  doCheck = !stdenv.hostPlatform.isMusl;

  meta = with lib; {
    description = "C Library for NVM Express on Linux";
    homepage = "https://github.com/linux-nvme/libnvme";
    maintainers = with maintainers; [ fogti vifino ];
    license = with licenses; [ lgpl21Plus ];
    platforms = platforms.linux;
  };
})
