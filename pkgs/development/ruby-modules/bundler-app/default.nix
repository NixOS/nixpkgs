{
  lib,
  callPackage,
  runCommand,
  makeWrapper,
  ruby,
}@defs:

# Use for simple installation of Ruby tools shipped in a Gem.
# Start with a Gemfile that includes `gem <toolgem>`
# > nix-shell -p bundler bundix
# (shell)> bundle lock
# (shell)> bundix
# Then use rubyTool in the default.nix:

# rubyTool { pname = "gemifiedTool"; gemdir = ./.; exes = ["gemified-tool"]; }
# The 'exes' parameter ensures that a copy of e.g. rake doesn't polute the system.
{
  # use the name of the name in question; its version will be picked up from the gemset
  pname,
  # Gemdir is the location of the Gemfile{,.lock} and gemset.nix; usually ./.
  # This is required unless gemfile, lockfile, and gemset are all provided
  gemdir ? null,
  # Exes is the list of executables provided by the gems in the Gemfile
  exes ? [ ],
  # Scripts are ruby programs depend on gems in the Gemfile (e.g. scripts/rails)
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
  postBuild ? "",
  gemConfig ? null,
  passthru ? { },
}@args:

let
  basicEnv =
    (callPackage ../bundled-common {
      inherit ruby;
    })
      args;

  cmdArgs =
    removeAttrs args [
      "pname"
      "postBuild"
      "gemConfig"
      "passthru"
      "gemset"
      "gemdir"
    ]
    // {
      inherit preferLocalBuild allowSubstitutes; # pass the defaults

      nativeBuildInputs = nativeBuildInputs ++ lib.optionals (scripts != [ ]) [ makeWrapper ];

      meta = {
        mainProgram = pname;
        inherit (ruby.meta) platforms;
      } // meta;
      passthru =
        basicEnv.passthru
        // {
          inherit basicEnv;
          inherit (basicEnv) env;
        }
        // passthru;
    };
in
runCommand basicEnv.name cmdArgs ''
  mkdir -p $out/bin
  ${(lib.concatMapStrings (x: "ln -s '${basicEnv}/bin/${x}' $out/bin/${x};\n") exes)}
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
  ''}
''
