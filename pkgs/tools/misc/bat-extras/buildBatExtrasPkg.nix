{
  lib,
  stdenv,
  core,

  bash,
  bat,
  fish,
  getconf,
  makeWrapper,
  nushell,
  zsh,
}:
let
  cleanArgs = lib.flip removeAttrs [
    "name"
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
    pname = name;
    inherit (core) version;

    src = core;

    nativeBuildInputs = [ makeWrapper ];
    # Make the dependencies available to the tests.
    buildInputs = dependencies;

    # Patch shebangs now because our tests rely on them
    postPatch = (args.postPatch or "") + ''
      patchShebangs --host bin/${name}
    '';

    dontConfigure = true;
    dontBuild = true; # we've already built it

    doCheck = args.doCheck or true;
    nativeCheckInputs = [
      bat
      bash
      fish
      nushell
      zsh
    ]
    ++ (lib.optionals stdenv.hostPlatform.isDarwin [ getconf ]);
    checkPhase = ''
      runHook preCheck
      bash ./test.sh --compiled --suite ${name} --verbose --snapshot:show
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

    # We have already patched
    dontPatchShebangs = true;

    meta = core.meta // { mainProgram = name; } // meta;
  }
)
