{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  nix-update-script,
  cython,
  setuptools,
  alsa-lib,
  ffmpeg,
  libopus,
  libuuid,
  libv4l,
  libvpx,
  opencore-amr,
  openssl,
  pkg-config,
  sqlite,
  x264,
  python3-application,
}:

let
  extDeps = {
    pjsip = rec {
      # Hardcoded in get_dependencies.sh, checked at buildtime
      # need tarball specifically for buildscript to detect it
      version = "2.10";
      src = fetchurl {
        url = "https://github.com/pjsip/pjproject/archive/${version}.tar.gz";
        hash = "sha256-k2pMW5hgG1IyVGOjl93xGrQQbGp7BPjcfN03fvu1l94=";
      };
      patches = [
        # Backported https://github.com/pjsip/pjproject/commit/4a8d180529d6ffb0760838b1f8cadc4cb5f7ac03
        ./pjsip-0001-NEON.patch

        # Backported https://github.com/pjsip/pjproject/commit/f56fd48e23982c47f38574a3fd93ebf248ef3762
        ./pjsip-0002-RISC-V.patch

        # Backported https://github.com/pjsip/pjproject/commit/f94b18ef6e0c0b5d34eb274f85ac0a3b2cf9107a
        ./pjsip-0003-LoongArch64.patch
      ];
    };
    zrtpcpp = rec {
      # Hardcoded in get_dependencies.sh, NOT checked at buildtime
      rev = "6b3cd8e6783642292bad0c21e3e5e5ce45ff3e03";
      src = fetchFromGitHub {
        owner = "wernerd";
        repo = "ZRTPCPP";
        inherit rev;
        hash = "sha256-kJlGPVA+yfn7fuRjXU0p234VcZBAf1MU4gRKuPotfog=";
      };
    };
  };

  applyPatchesWhenAvailable =
    extDep: dir:
    lib.optionalString (extDep ? patches) (
      lib.strings.concatMapStringsSep "\n" (patch: ''
        echo "Applying patch ${patch}"
        patch -p1 -d ${dir} < ${patch}
      '') extDep.patches
    );
in
buildPythonPackage rec {
  pname = "python3-sipsimple";
  version = "5.3.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-sipsimple";
    tag = "${version}-mac";
    hash = "sha256-kDXVzLmgfXxm8phKrV7DvPuZ9O2iNFo1s6Lc0jcc/dM=";
  };

  patches = [
    # Remove when version > 5.3.3.2-mac
    (fetchpatch {
      name = "0001-python3-sipsimple-port-to-cython-3.patch";
      url = "https://github.com/AGProjects/python3-sipsimple/commit/ccbbbb0225b2417bdf6ae07da96bffe367e242be.patch";
      hash = "sha256-MBiM9/yS5yX9QoZT7p76PI2rbBr22fZw6TAT4tw9iZk=";
    })
  ];

  postPatch = ''
    substituteInPlace get_dependencies.sh \
      --replace-fail 'sudo apt' 'echo Skipping sudo apt'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [
    alsa-lib
    ffmpeg
    libopus
    libuuid
    libv4l
    libvpx
    opencore-amr
    openssl
    sqlite
    x264
  ];

  dependencies = [
    python3-application
  ];

  preConfigure = ''
    ln -s ${passthru.extDeps.pjsip.src} deps/${passthru.extDeps.pjsip.version}.tar.gz
    cp -r --no-preserve=all ${passthru.extDeps.zrtpcpp.src} deps/ZRTPCPP

    bash ./get_dependencies.sh
  ''
  + applyPatchesWhenAvailable extDeps.pjsip "deps/pjsip"
  + applyPatchesWhenAvailable extDeps.zrtpcpp "deps/ZRTPCPP"
  + ''
    # Fails to link some static libs due to missing -lc DSO. Just use the compiler frontend instead of raw ld.
    substituteInPlace deps/pjsip/build/rules.mak \
      --replace-fail '$(LD)' "$CC"

    # Incompatible pointers (not const)
    substituteInPlace deps/pjsip/pjmedia/src/pjmedia-codec/ffmpeg_vid_codecs.c \
      --replace-fail '&payload,' '(const pj_uint8_t **)&payload,'
  '';

  # no upstream tests exist
  doCheck = false;

  pythonImportsCheck = [ "sipsimple" ];

  passthru = {
    inherit extDeps;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^(.*)-mac$"
      ];
    };
  };

  meta = {
    description = "SIP SIMPLE SDK written in Python";
    homepage = "https://sipsimpleclient.org/";
    downloadPage = "https://github.com/AGProjects/python3-sipsimple";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.ngi ];
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}
