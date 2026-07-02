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
    "shellInit"
  ];
in
{
  name,
  dependencies,
  meta ? { },
  # Config for the `shellInit` passthru (a `shell -> string`
  # function returning the shell-specific init snippet for the bat-extras
  # package). Specified as an attrset with a 'flags' string list argument.
  # If null, there is no shell init for the package.
  shellInit ? null,
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

    passthru =
      let
        initScript =
          {
            program,
            shell,
            flags ? [ ],
          }:
          if (shell != "fish") then
            ''
              eval "$(${lib.getExe program} ${toString flags})"
            ''
          else
            ''
              ${lib.getExe program} ${toString flags} | source
            '';
      in
      {
        shellInit =
          shell:
          if shellInit == null then
            ""
          else
            initScript {
              program = finalAttrs.finalPackage;
              inherit shell;
              flags = shellInit.flags or [ ];
            };
      };

    meta = core.meta // { mainProgram = name; } // meta;
  }
)
