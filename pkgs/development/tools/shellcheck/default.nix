{ stdenv, lib, ShellCheck, haskell, pandoc }:

# this wraps around the haskell package
# and puts the documentation into place

let
  # TODO: move to lib/ in separate PR
  overrideMeta = drv: overrideFn:
    let
<<<<<<< HEAD
      drv' = if drv ? meta then drv else drv // { meta = { }; };
=======
      drv' = if drv ? meta then drv else drv // { meta = {}; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      pos = (builtins.unsafeGetAttrPos "pname" drv');
      meta' = drv'.meta // {
        # copied from the mkDerivation code
        position = pos.file + ":" + toString pos.line;
      };
<<<<<<< HEAD
    in
    drv' // { meta = meta' // overrideFn meta'; };
=======
    in drv' // { meta = meta' // overrideFn meta'; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  bin = haskell.lib.compose.justStaticExecutables ShellCheck;

  shellcheck = stdenv.mkDerivation {
    pname = "shellcheck";
    version = bin.version;

    inherit (ShellCheck) meta src;

    nativeBuildInputs = [ pandoc ];

    outputs = [ "bin" "man" "doc" "out" ];

    buildPhase = ''
      pandoc -s -f markdown-smart -t man shellcheck.1.md -o shellcheck.1
    '';

    installPhase = ''
      install -Dm755 ${bin}/bin/shellcheck $bin/bin/shellcheck
      install -Dm644 README.md $doc/share/shellcheck/README.md
      install -Dm644 shellcheck.1 $man/share/man/man1/shellcheck.1
      mkdir $out
    '';

<<<<<<< HEAD
    passthru = ShellCheck.passthru or { } // {
=======
    passthru = ShellCheck.passthru or {} // {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      # pandoc takes long to build and documentation isn't needed for in nixpkgs usage
      unwrapped = ShellCheck;
    };
  };

in
<<<<<<< HEAD
overrideMeta shellcheck (old: {
  maintainers = with lib.maintainers; [ zowoq ];
  mainProgram = "shellcheck";
  outputsToInstall = [ "bin" "man" "doc" ];
})
=======
  overrideMeta shellcheck (old: {
    maintainers = with lib.maintainers; [ Profpatsch zowoq ];
    outputsToInstall = [ "bin" "man" "doc" ];
  })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
