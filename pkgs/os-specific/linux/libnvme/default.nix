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
, fetchpatch
# ImportError: cannot import name 'mlog' from 'mesonbuild'
, withDocs ? stdenv.hostPlatform.canExecute stdenv.buildPlatform
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnvme";
  version = "1.6";

  outputs = [ "out" ] ++ lib.optionals withDocs [ "man" ];

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "libnvme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7bvjsmt16/6RycSDKIECtJ4ES7NTaspU6IMpUw0sViA=";
  };

  patches = [
    # included in next release
    (fetchpatch {
      url = "https://github.com/linux-nvme/libnvme/commit/ff742e792725c316ba6de0800188bf36751bd1d1.patch";
      hash = "sha256-IUjPUBmGQC4oAKFFlBrjonqD2YdyNPC9siK4t/t2slE=";
    })
    # included in next release
    (fetchpatch {
      url = "https://github.com/linux-nvme/libnvme/commit/a2b8e52e46cfd888ac5a48d8ce632bd70a5caa93.patch";
      hash = "sha256-AVSWraFriErfz7dA2CjU8+ehJtAmuLxBZyBALygmrf0=";
    })
    # included in next release
    (fetchpatch {
      url = "https://github.com/linux-nvme/libnvme/commit/68c6ffb11d40a427fc1fd70ac2ac97fd01952913.patch";
      hash = "sha256-dvc1sjgCFU31/LornvJ/aRVYtPOsewkas0jS+/AwFuU=";
    })
  ];

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
