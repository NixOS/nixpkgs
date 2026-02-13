{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  kcmutils,
  kconfig,
  kcoreaddons,
  ki18n,
  kio,
  qcoro,
  qtbase,
  python3,
}:

let
  python = python3.withPackages (
    p: with p; [
      httpx
      dbus-fast
      typer
      rich
      pyyaml
      pydantic
    ]
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "kapsule";
  version = "0-unstable-2026-02-10";

  patches = [
    ./path-fix.patch
  ];

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "kde-linux";
    repo = "kapsule";
    rev = "d311acfdef187433568e32fada90a0f6dcfaac9b";
    hash = "sha256-cnk6J6DF1tjxfhjvgu99yWv1f0y2q3VBEXjVDvOYFTM=";
  };

  postPatch = ''
    substituteInPlace data/systemd/system/kapsule-daemon.service \
      --replace-fail \
      "Environment=PYTHONPATH=@KAPSULE_VENDOR_DIR@:@KAPSULE_PYTHON_DIR@" \
      "Environment=PYTHONPATH=${python}/${python.sitePackages}:$out/share/kapsule/python"
    substituteInPlace src/daemon/config.py \
      --replace-fail "/usr/" "$out/"
  '';

  # Let the NixOS module handle this.
  postInstall = ''
    rm $out/lib/systemd/system/incus.service.d/kapsule-log-dir.conf
  '';

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "VENDOR_PYTHON_DEPS" false)
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kcmutils
    kconfig
    kcoreaddons
    ki18n
    kio
    qcoro
    qtbase
    python3
  ];

  outputs = [
    "out"
    "dev"
  ];
})
