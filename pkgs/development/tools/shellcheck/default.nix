{
  stdenv,
  lib,
  ShellCheck,
  haskell,
  pandoc,
}:

# this wraps around the haskell package
# and puts the documentation into place

let
  # TODO: move to lib/ in separate PR
  overrideMeta =
    drv: overrideFn:
    let
      drv' = if drv ? meta then drv else drv // { meta = { }; };
      pos = (builtins.unsafeGetAttrPos "pname" drv');
      meta' = drv'.meta // {
        # copied from the mkDerivation code
        position = pos.file + ":" + toString pos.line;
      };
    in
    drv' // { meta = meta' // overrideFn meta'; };

  bin = haskell.lib.compose.justStaticExecutables ShellCheck;

  shellcheck = stdenv.mkDerivation {
    pname = "shellcheck";
    version = bin.version;

    inherit (ShellCheck) meta src;

    nativeBuildInputs = [ pandoc ];

    outputs = [
      "bin"
      "man"
      "doc"
      "out"
    ];

    buildPhase = ''
      pandoc -s -f markdown-smart -t man shellcheck.1.md -o shellcheck.1
    '';

    installPhase = ''
      install -Dm755 ${bin}/bin/shellcheck $bin/bin/shellcheck
      install -Dm644 README.md $doc/share/shellcheck/README.md
      install -Dm644 shellcheck.1 $man/share/man/man1/shellcheck.1
      mkdir $out
    '';

    passthru = ShellCheck.passthru or { } // {
      # pandoc takes long to build and documentation isn't needed for in nixpkgs usage
      unwrapped = ShellCheck;
    };
  };

in
overrideMeta shellcheck (old: {
  maintainers = with lib.maintainers; [ zowoq ];
  mainProgram = "shellcheck";
  outputsToInstall = [
    "bin"
    "man"
    "doc"
  ];
})
