{ fetchFromGitHub
, bash
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
  version = "1.9";

  outputs = [ "out" ] ++ lib.optionals withDocs [ "man" ];

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "libnvme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nXzYbj4BDxFii30yR+aTgqjQfyYMFiAIcV/OHI2y5Ws=";
  };

  postPatch = ''
    patchShebangs scripts
    substituteInPlace test/sysfs/sysfs-tree-diff.sh \
      --replace-fail /bin/bash ${bash}/bin/bash
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
    maintainers = with maintainers; [ vifino ];
    license = with licenses; [ lgpl21Plus ];
    platforms = platforms.linux;
  };
})
