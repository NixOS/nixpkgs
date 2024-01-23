{ lib
, fetchFromGitHub
, fetchpatch
, stdenv
, python3
, bubblewrap
, systemd
, pandoc
, kmod
, gnutar
, util-linux
, cpio
, bash
, coreutils
, btrfs-progs

  # Python packages
, setuptools
, setuptools-scm
, wheel
, buildPythonApplication
, pytestCheckHook
, pefile

  # Optional dependencies
, withQemu ? false
, qemu
, OVMF
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
  };

  python3pefile = python3.withPackages (ps: with ps; [
    pefile
  ]);
in
buildPythonApplication rec {
  pname = "mkosi";
  version = "20.1";
  format = "pyproject";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "mkosi";
    rev = "v${version}";
    hash = "sha256-gkn5d9ybfrV/QYKSUyzyHAouU++NCEBDT22zFMrEZt8=";
  };

  # Fix ctypes finding library
  # https://github.com/NixOS/nixpkgs/issues/7307
  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace mkosi/run.py \
      --replace 'ctypes.util.find_library("c")' "'${stdenv.cc.libc}/lib/libc.so.6'"
    substituteInPlace mkosi/__init__.py \
      --replace '/usr/lib/systemd/ukify' "${systemdForMkosi}/lib/systemd/ukify"
  '' + lib.optionalString withQemu ''
    substituteInPlace mkosi/qemu.py \
      --replace '/usr/share/ovmf/x64/OVMF_VARS.fd' "${OVMF.variables}" \
      --replace '/usr/share/ovmf/x64/OVMF_CODE.fd' "${OVMF.firmware}"
  '';

  nativeBuildInputs = [
    pandoc
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    bash
    btrfs-progs
    bubblewrap
    coreutils
    cpio
    gnutar
    kmod
    systemdForMkosi
    util-linux
  ] ++ lib.optional withQemu [
    qemu
  ];

  postBuild = ''
    ./tools/make-man-page.sh
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mkosi"
  ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    mv mkosi/resources/mkosi.1 $out/share/man/man1/
  '';

  makeWrapperArgs = [
    "--set MKOSI_INTERPRETER ${python3pefile}/bin/python3"
    "--prefix PYTHONPATH : \"$PYTHONPATH\""
  ];

  meta = with lib; {
    description = "Build legacy-free OS images";
    homepage = "https://github.com/systemd/mkosi";
    changelog = "https://github.com/systemd/mkosi/releases/tag/v${version}";
    license = licenses.lgpl21Only;
    mainProgram = "mkosi";
    maintainers = with maintainers; [ malt3 katexochen ];
    platforms = platforms.linux;
  };
}
