{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  radare2,
  zlib,
}:
let
  ghidra-native-src = fetchFromGitHub {
    owner = "radareorg";
    repo = "ghidra-native";
    tag = "0.6.4";
    hash = "sha256-DFvHM/erGE9wFjcB3Dlyhv4oebzXwe2yGG+GzLaY7hU=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "r2ghidra";
  version = "6.1.8";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "r2ghidra";
    tag = finalAttrs.version;
    hash = "sha256-f5iohbAUYG524KJqSvL3PQCFnLQc055Ta02G3CRSO9I=";
  };

  postUnpack = ''
    rm -rf $sourceRoot/subprojects/ghidra-native
    cp -r ${ghidra-native-src} $sourceRoot/subprojects/ghidra-native
    chmod -R u+w $sourceRoot/subprojects/ghidra-native
    cp $sourceRoot/subprojects/packagefiles/ghidra-native/meson.build \
      $sourceRoot/subprojects/ghidra-native/meson.build
    for p in $sourceRoot/subprojects/packagefiles/ghidra-native/patches/*.patch; do
      patch -d $sourceRoot/subprojects/ghidra-native -p1 < "$p"
    done
    # Shadows libc++'s <version> header when meson adds the subproject root to
    # the include search path.
    rm -f $sourceRoot/subprojects/ghidra-native/version
  '';

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
        "res = run_command(['radare2','-HR2_LIBR_PLUGINS'], capture:true, check:false)
    if res.returncode() == 0
      r2_plugdir = res.stdout().strip()
    else
      prefix = get_option('prefix')
      r2_plugdir = prefix + '/lib/radare2/plugins'
    endif" \
        "r2_plugdir = get_option('prefix') + '/lib/radare2/plugins'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    radare2
    zlib
  ];

  mesonFlags = [
    (lib.mesonBool "rxml" true)
  ];

  meta = {
    description = "Deep integration of Ghidra decompiler in radare2";
    homepage = "https://github.com/radareorg/r2ghidra";
    changelog = "https://github.com/radareorg/r2ghidra/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      lgpl3Only
      asl20 # ghidra-native (decompiler core)
    ];
    maintainers = with lib.maintainers; [ theoparis ];
    platforms = lib.platforms.unix;
  };
})
