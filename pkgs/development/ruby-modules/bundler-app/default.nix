{
  stdenvNoCC,
  lib,
  callPackage,
  makeWrapper,
  ruby,
}@defs:

# Use for simple installation of Ruby tools shipped in a Gem.
# Start with a Gemfile that includes `gem <toolgem>`
# > nix-shell -p bundler bundix
# (shell)> bundle lock
# (shell)> bundix
# Then use bundlerApp in the default.nix:

# bundlerApp { pname = "gemifiedTool"; gemdir = ./.; exes = ["gemified-tool"]; }

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  excludeDrvArgNames = [
    # Special arguments
    "exes"
    "installManpages"
    "ruby"
    "scripts"
    # Arguments which are only passed to bundled-common
    "gemConfig"
    "gemdir"
    "gemfile"
    "gemset"
    "lockfile"
    "postBuild"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      # use the name of the gem in question; its version will be picked up from the gemset
      pname,
      # Gemdir is the location of the Gemfile{,.lock} and gemset.nix; usually ./.
      # This is required unless gemfile, lockfile, and gemset are all provided
      gemdir ? null,
      # Exes is the list of executables provided by the gems in the Gemfile. This ensures that a copy of rake,
      # for example, doesn't pollute the system.
      exes ? [ ],
      # Scripts are ruby programs which depend on gems in the Gemfile (e.g. scripts/rails)
      scripts ? [ ],
      ruby ? defs.ruby,
      gemfile ? null,
      lockfile ? null,
      gemset ? null,
      preferLocalBuild ? false,
      allowSubstitutes ? false,
      installManpages ? true,
      meta ? { },
      nativeBuildInputs ? [ ],
      buildInputs ? [ ],
      gemConfig ? null,
      passthru ? { },
      ...
    }@args:
    let
      basicEnv = (callPackage ../bundled-common { inherit ruby; }) args;
    in
    {
      __structuredAttrs = true;
      inherit preferLocalBuild allowSubstitutes; # pass the defaults
      inherit pname;
      inherit (basicEnv) version;

      nativeBuildInputs = nativeBuildInputs ++ [ makeWrapper ];
      strictDeps = true;

      dontUnpack = true;
      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        ${lib.concatMapStrings (x: ''
          makeWrapper '${basicEnv}/bin/${x}' $out/bin/${x}
        '') exes}
        ${
          (lib.concatMapStrings (
            s:
            "makeWrapper $out/bin/$(basename ${s}) $srcdir/${s} "
            + "--set BUNDLE_GEMFILE ${basicEnv.confFiles}/Gemfile "
            + "--unset BUNDLE_PATH "
            + "--set BUNDLE_FROZEN 1 "
            + "--set GEM_HOME ${basicEnv}/${ruby.gemPath} "
            + "--set GEM_PATH ${basicEnv}/${ruby.gemPath} "
            + "--chdir \"$srcdir\";\n"
          ) scripts)
        }

        ${lib.optionalString installManpages ''
          for section in {1..9}; do
            mandir="$out/share/man/man$section"

            # See: https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/ruby-modules/gem/default.nix#L184-L200
            # See: https://github.com/rubygems/rubygems/blob/7a7b234721c375874b7e22b1c5b14925b943f04e/bundler/lib/bundler.rb#L285-L291
            find -L ${basicEnv}/${ruby.gemPath}/${
              lib.optionalString (basicEnv.gemType == "git" || basicEnv.gemType == "url") "bundler/"
            }gems/${basicEnv.name} \( -wholename "*/man/*.$section" -o -wholename "*/man/man$section/*.$section" \) -print -execdir mkdir -p $mandir \; -execdir cp '{}' $mandir \;
          done
          compressManPages "''${!outputMan}"
        ''}

        runHook postInstall
      '';

      meta = {
        mainProgram = pname;
        inherit (ruby.meta) platforms;
      }
      // meta;
      passthru =
        basicEnv.passthru
        // {
          inherit basicEnv;
          inherit (basicEnv) env;
        }
        // passthru;
    };
}
