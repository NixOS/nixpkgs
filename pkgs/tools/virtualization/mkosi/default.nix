{
  lib,
  fetchFromGitHub,
  stdenv,
  python3,
  systemd,
  pandoc,
  kmod,
  gnutar,
  util-linux,
  cpio,
  bash,
  coreutils,
  btrfs-progs,
  libseccomp,
  replaceVars,

  # Python packages
  setuptools,
  setuptools-scm,
  wheel,
  buildPythonApplication,
  pytestCheckHook,
  pefile,

  # Optional dependencies
  withQemu ? false,
  qemu,
}:
let
  # For systemd features used by mkosi, see
  # https://github.com/systemd/mkosi/blob/19bb5e274d9a9c23891905c4bcbb8f68955a701d/action.yaml#L64-L72
  systemdForMkosi = systemd.override {
    withRepart = true;
    withBootloader = true;
    withSysusers = true;
    withFirstboot = true;
    withEfi = true;
    withUkify = true;
    withKernelInstall = true;
  };

  python3pefile = python3.withPackages (
    ps: with ps; [
      pefile
    ]
  );
in
buildPythonApplication rec {
  pname = "mkosi";
  version = "24.3-unstable-2024-08-28";
  format = "pyproject";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "mkosi";
    rev = "8c2f828701a1bdb3dc9b80d6f2ab979f0430a6b8";
    hash = "sha256-rO/4ki2nAJQN2slmYuHKESGBBDMXC/ikGf6dMDcKFr4=";
  };

  patches =
    [
      (replaceVars ./0001-Use-wrapped-binaries-instead-of-Python-interpreter.patch {
        UKIFY = "${systemdForMkosi}/lib/systemd/ukify";
        PYTHON_PEFILE = "${python3pefile}/bin/python3.12";
        MKOSI_SANDBOX = "~MKOSI_SANDBOX~"; # to satisfy replaceVars, will be replaced in postPatch
      })
      (replaceVars ./0002-Fix-library-resolving.patch {
        LIBC = "${stdenv.cc.libc}/lib/libc.so.6";
        LIBSECCOMP = "${libseccomp.lib}/lib/libseccomp.so.2";
      })
    ]
    ++ lib.optional withQemu (
      replaceVars ./0003-Fix-QEMU-firmware-path.patch {
        QEMU_FIRMWARE = "${qemu}/share/qemu/firmware";
      }
    );

  postPatch = ''
    # As we need the $out reference, we can't use `replaceVars` here.
    substituteInPlace mkosi/run.py \
      --replace-fail '~MKOSI_SANDBOX~' "\"$out/bin/mkosi-sandbox\""
  '';

  nativeBuildInputs = [
    pandoc
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs =
    [
      bash
      btrfs-progs
      coreutils
      cpio
      gnutar
      kmod
      systemdForMkosi
      util-linux
    ]
    ++ lib.optional withQemu [
      qemu
    ];

  postBuild = ''
    ./tools/make-man-page.sh
  '';

  checkInputs = [
    pytestCheckHook
  ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    mv mkosi/resources/mkosi.1 $out/share/man/man1/
  '';

  meta = with lib; {
    description = "Build legacy-free OS images";
    homepage = "https://github.com/systemd/mkosi";
    changelog = "https://github.com/systemd/mkosi/releases/tag/v${version}";
    license = licenses.lgpl21Only;
    mainProgram = "mkosi";
    maintainers = with maintainers; [
      malt3
      msanft
    ];
    platforms = platforms.linux;
    # `mkosi qemu` boot fails in the uefi shell, image isn't found.
    broken = withQemu;
  };
}
