{ stdenv, lib, haskellPackages, haskell }:

# this wraps around the haskell package
# and puts the documentation into place

let
  # TODO: move to lib/ in separate PR
  overrideMeta = drv: overrideFn:
    let
      drv' = if drv ? meta then drv else drv // { meta = {}; };
      pos = (builtins.unsafeGetAttrPos "pname" drv');
      meta' = drv'.meta // {
        # copied from the mkDerivation code
        position = pos.file + ":" + toString pos.line;
      };
    in drv' // { meta = meta' // overrideFn meta'; };

  bin = haskell.lib.justStaticExecutables haskellPackages.ShellCheck;
  src = haskellPackages.ShellCheck.src;

  shellcheck = stdenv.mkDerivation {
    pname = "shellcheck";
    version = bin.version;

    inherit src;

    outputs = [ "bin" "man" "doc" "out" ];

    phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

    installPhase = ''
      install -Dm755 ${bin}/bin/shellcheck $bin/bin/shellcheck
      install -Dm644 README.md $doc/share/shellcheck/README.md
      install -Dm644 shellcheck.1 $man/share/man/man1/shellcheck.1
      mkdir $out
    '';

    # just some file copying
    preferLocalBuild = true;
    allowSubstitutes = false;
  };

in
  overrideMeta shellcheck (old: {
    maintainers = with lib.maintainers; [ Profpatsch ];
    outputsToInstall = [ "bin" "man" "doc" ];
  })
