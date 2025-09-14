{
  lib,
  python3Packages,
  fetchFromGitHub,
  stdenv,
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
  udevCheckHook,

  # Optional dependencies
  withQemu ? false,
  qemu,

  # Workaround for supporting providing additional package manager
  # dependencies in the recursive use in the binary path.
  # This can / should be removed once the `finalAttrs` pattern is
  # available for Python packages.
  extraDeps ? [ ],
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

  pythonWithPefile = python3Packages.python.withPackages (ps: [ ps.pefile ]);

  deps = [
    bash
    btrfs-progs
    coreutils
    cpio
    gnutar
    kmod
    systemdForMkosi
    util-linux
  ]
  ++ extraDeps
  ++ lib.optionals withQemu [
    qemu
  ];
in
python3Packages.buildPythonApplication rec {
  pname = "mkosi";
  version = "25.3";
  format = "pyproject";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "mkosi";
    rev = "21850673a7f75125d516268ce379dae776dd816a";
    hash = "sha256-3dhr9lFJpI8aN8HILaMvGuuTbmTVUqdaLAGxSpqciTs=";
  };

  patches = [
    (replaceVars ./0001-Use-wrapped-binaries-instead-of-Python-interpreter.patch {
      UKIFY = "${systemdForMkosi}/lib/systemd/ukify";
      PYTHON_PEFILE = lib.getExe pythonWithPefile;
      NIX_PATH = toString (lib.makeBinPath deps);
      MKOSI_SANDBOX = null; # will be replaced in postPatch
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
    substituteInPlace mkosi/{run,__init__}.py \
      --replace-fail '@MKOSI_SANDBOX@' "\"$out/bin/mkosi-sandbox\""
  '';

  nativeBuildInputs = [
    pandoc
    python3Packages.setuptools
    python3Packages.setuptools-scm
    python3Packages.wheel
    udevCheckHook
  ];

  dependencies = deps;

  postBuild = ''
    ./tools/make-man-page.sh
  '';

  checkInputs = [
    python3Packages.pytestCheckHook
  ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    mv mkosi/resources/man/mkosi.1 $out/share/man/man1/
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
  };
}
