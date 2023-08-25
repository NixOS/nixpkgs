{ lib
, fetchFromGitHub
, fetchpatch
, stdenv
, python3
, bubblewrap
, systemd

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
  systemdForMkosi = (systemd.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      # Enable setting a deterministic verity seed for systemd-repart. Remove when upgrading to systemd 255.
      (fetchpatch {
        url = "https://github.com/systemd/systemd/commit/81e04781106e3db24e9cf63c1d5fdd8215dc3f42.patch";
        hash = "sha256-KO3poIsvdeepPmXWQXNaJJCPpmBb4sVmO+ur4om9f5k=";
      })
    ];
  })).override {
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
  version = "15.2-pre"; # 15.1 is the latest release, but we require a newer commit
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "mkosi";
    # Fix from the commit is needed to run on NixOS,
    # see https://github.com/systemd/mkosi/issues/1792
    rev = "ca9673cbcbd9f293e5566cec4a1ba14bbcd075b8";
    hash = "sha256-y5gG/g33HBpH1pTXfjHae25bc5p/BvlCm9QxOIYtcA8=";
  };

  # Fix ctypes finding library
  # https://github.com/NixOS/nixpkgs/issues/7307
  patchPhase = lib.optionalString stdenv.isLinux ''
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
    setuptools
    setuptools-scm
    wheel
  ];

  makeWrapperArgs = [
    "--set MKOSI_INTERPRETER ${python3pefile}/bin/python3"
  ];

  propagatedBuildInputs = [
    systemdForMkosi
    bubblewrap
  ] ++ lib.optional withQemu [
    qemu
  ];

  postInstall = ''
    wrapProgram $out/bin/mkosi \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Build legacy-free OS images";
    homepage = "https://github.com/systemd/mkosi";
    license = licenses.lgpl21Only;
    mainProgram = "mkosi";
    maintainers = with maintainers; [ malt3 katexochen ];
    platforms = platforms.linux;
  };
}
