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
      # Propagate SOURCE_DATE_EPOCH to mcopy. Remove when upgrading to systemd 255.
      (fetchpatch {
        url = "https://github.com/systemd/systemd/commit/4947de275a5553399854cc748f4f13e4ae2ba069.patch";
        hash = "sha256-YIZZyc3f8pQO9fMAxiNhDdV8TtL4pXoh+hwHBzRWtfo=";
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
  version = "17.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "mkosi";
    rev = "v${version}";
    hash = "sha256-v6so6MFOkxPOnPDgAgni517NX4vUnkPd7o4UMSUHL24=";
  };

  patches = [
    (fetchpatch {
      # Fix tests. Remove in next release.
      url = "https://github.com/systemd/mkosi/commit/3e2642c743b2ccb78fd0a99e75993824034f7124.patch";
      hash = "sha256-x9xb8Pz7l2FA8pfhQd7KqITxbnjjwBUh0676uggcukI=";
    })
  ];

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
    changelog = "https://github.com/systemd/mkosi/releases/tag/v${version}";
    license = licenses.lgpl21Only;
    mainProgram = "mkosi";
    maintainers = with maintainers; [ malt3 katexochen ];
    platforms = platforms.linux;
  };
}
