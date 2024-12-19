# idea: provide a build environments for your developement of preference
/*
  #### examples of use: ####
  # Add this to your ~/.config/nixpkgs/config.nix:
  {
    packageOverrides = pkgs : with pkgs; {
      sdlEnv = pkgs.myEnvFun {
          name = "sdl";
          nativeBuildInputs = [ cmake pkg-config ];
          buildInputs = [ stdenv SDL SDL_image SDL_ttf SDL_gfx SDL_net];
      };
    };
  }

  # Then you can install it by:
  #  $ nix-env -i env-sdl
  # And you can load it simply calling:
  #  $ load-env-sdl
  # and this will update your env vars to have 'make' and 'gcc' finding the SDL
  # headers and libs.

  ##### Another example, more complicated but achieving more: #######
  # Make an environment to build nix from source and create ctags (tagfiles can
  # be extracted from TAG_FILES) from every source package. Here would be a
  # full ~/.config/nixpkgs/config.nix
  {
    packageOverrides = pkgs : with pkgs; with sourceAndTags;
    let complicatedMyEnv = { name, buildInputs ? [], cTags ? [], extraCmds ? ""}:
            pkgs.myEnvFun {
              inherit name;
            buildInputs = buildInputs
                  ++ map (x : sourceWithTagsDerivation
                    ( (addCTaggingInfo x ).passthru.sourceWithTags ) ) cTags;
            extraCmds = ''
              ${extraCmds}
              HOME=${builtins.getEnv "HOME"}
              . ~/.bashrc
            '';
          };
    in rec {
      # this is the example we will be using
      nixEnv = complicatedMyEnv {
        name = "nix";
        buildInputs = [ libtool stdenv perl curl bzip2 openssl db5 autoconf automake zlib ];
      };
    };
  }

  # Now we should build our newly defined custom environment using this command on a shell, so type:
  #  $ nix-env -i env-nix

  # You can load the environment simply typing a "load-env-${name}" command.
  #  $ load-env-nix
  # The result using that command should be:
  #  env-nix loaded
  and show you a shell with a prefixed prompt.
*/

{
  mkDerivation,
  replaceVars,
  pkgs,
}:
{
  stdenv ? pkgs.stdenv,
  name,
  buildInputs ? [ ],
  propagatedBuildInputs ? [ ],
  extraCmds ? "",
  cleanupCmds ? "",
  shell ? "${pkgs.bashInteractive}/bin/bash --norc",
}:

mkDerivation {
  inherit buildInputs propagatedBuildInputs;

  name = "env-${name}";
  phases = [
    "buildPhase"
    "fixupPhase"
  ];
  setupNew = ../../stdenv/generic/setup.sh;

  buildPhase =
    let
      initialPath = import ../../stdenv/generic/common-path.nix { inherit pkgs; };
    in
    ''
      set -x
      mkdir -p "$out/dev-envs" "$out/nix-support" "$out/bin"
      s="$out/nix-support/setup-new-modified"
      # shut some warning up.., do not use set -e
      sed -e 's@set -eu@@' \
          -e 's@assertEnvExists\s\+NIX_STORE@:@' \
          -e 's@trap.*@@' \
          -e '1i initialPath="${toString initialPath}"' \
          "$setupNew" > "$s"
      cat >> "$out/dev-envs/''${name/env-/}" << EOF
        defaultNativeBuildInputs="$defaultNativeBuildInputs"
        buildInputs="$buildInputs"
        propagatedBuildInputs="$propagatedBuildInputs"
        # the setup-new script wants to write some data to a temp file.. so just let it do that and tidy up afterwards
        tmp="\$("${pkgs.coreutils}/bin/mktemp" -d)"
        NIX_BUILD_TOP="\$tmp"
        phases=
        # only do all the setup stuff in nix-support/*
        set +e
        # This prevents having -rpath /lib in NIX_LDFLAGS
        export NIX_NO_SELF_RPATH=1
        if [[ -z "\$ZSH_VERSION" ]]; then
          source "$s"
        else
          setopt interactivecomments
          # fix bash indirection
          # let's hope the bash arrays aren't used
          # substitute is using bash array, so skip it
          echo '
              setopt NO_BAD_PATTERN
              setopt NO_BANG_HIST
              setopt NO_BG_NICE
              setopt NO_EQUALS
              setopt NO_FUNCTION_ARGZERO
              setopt GLOB_SUBST
              setopt NO_HUP
              setopt INTERACTIVE_COMMENTS
              setopt KSH_ARRAYS
              setopt NO_MULTIOS
              setopt NO_NOMATCH
              setopt RM_STAR_SILENT
              setopt POSIX_BUILTINS
              setopt SH_FILE_EXPANSION
              setopt SH_GLOB
              setopt SH_OPTION_LETTERS
              setopt SH_WORD_SPLIT
            ' >> "\$tmp/script"
          sed -e 's/\''${!\([^}]*\)}/\''${(P)\1}/g' \
              -e 's/[[]\*\]//' \
              -e 's/substitute() {/ substitute() { return; /' \
              -e 's@PATH=\$@PATH=${pkgs.coreutils}/bin@' \
              "$s" >> "\$tmp/script"
          echo "\$tmp/script";
          source "\$tmp/script";
        fi
        ${pkgs.coreutils}/bin/rm -fr "\$tmp"
        ${extraCmds}

        nix_cleanup() {
          :
          ${cleanupCmds}
        }

        export PATH
        echo $name loaded >&2

        trap nix_cleanup EXIT
      EOF

      mkdir -p $out/bin
      sed -e 's,@shell@,${shell},' -e s,@myenvpath@,$out/dev-envs/${name}, \
        -e 's,@name@,${name},' ${./loadenv.sh} > $out/bin/load-env-${name}
      chmod +x $out/bin/load-env-${name}
    '';
}
