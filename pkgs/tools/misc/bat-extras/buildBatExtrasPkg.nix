{
  lib,
  stdenv,
  core,

  bash,
  bat,
  fish,
  getconf,
  makeWrapper,
  zsh,
}:
let
  cleanArgs = lib.flip removeAttrs [
    "dependencies"
    "meta"
  ];
in
{
  name,
  dependencies,
  meta ? { },
  ...
}@args:
stdenv.mkDerivation (
  finalAttrs:
  cleanArgs args
  // {
    inherit (core) version;

    src = core;

    nativeBuildInputs = [ makeWrapper ];
    # Make the dependencies available to the tests.
    buildInputs = dependencies;

    # Patch shebangs now because our tests rely on them
    postPatch = ''
      patchShebangs --host bin/${name}
    '';

    dontConfigure = true;
    dontBuild = true; # we've already built

    doCheck = true;
    nativeCheckInputs = [
      bat
      bash
      fish
      zsh
    ]
    ++ (lib.optionals stdenv.hostPlatform.isDarwin [ getconf ]);
    checkPhase = ''
      runHook preCheck
      bash ./test.sh --compiled --suite ${name}
      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp -p bin/${name} $out/bin/${name}
    ''
    + lib.optionalString (dependencies != [ ]) ''
      wrapProgram $out/bin/${name} \
        --prefix PATH : ${lib.makeBinPath dependencies}
    ''
    + ''
      runHook postInstall
    '';

    # We already patched
    dontPatchShebangs = true;

    meta = core.meta // { mainProgram = name; } // meta;
  }
)
