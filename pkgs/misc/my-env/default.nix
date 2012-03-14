# idea: provide nix environment for your developement actions
# experimental

/*
  # example:
  # add postgresql to environment and create ctags (tagfiles can be extracted from TAG_FILES)
  # add this to your ~/.nixpkgs/config.nix

  {
    packageOverrides = pkgs : with pkgs; with sourceAndTags;
    let simple = { name, buildInputs ? [], cTags ? [], extraCmds ? ""}:
            pkgs.myEnvFun {
              inherit name;
            buildInputs = buildInputs 
                  ++ map (x : sourceWithTagsDerivation ( (addCTaggingInfo x ).passthru.sourceWithTags ) ) cTags;
            extraCmds = ''
              ${extraCmds}
              HOME=${builtins.getEnv "HOME"}
              . ~/.bashrc
            '';
          };
    in rec {
      # this is the example we will be using
      nixEnv = simple {
       name = "mytestenv";
       buildInputs = [ libtool stdenv perl curl bzip2 openssl db45 autoconf automake zlib ];
      };
      # this is a second example (not covered here but still useful) - given by viric
      sdlEnv = pkgs.myEnvFun {
          name = "sdl";
          buildInputs = [ stdenv SDL SDL_image SDL_ttf SDL_gfx cmake SDL_net  pkgconfig];
      };
      # add more environments below here, just follow the syntax given in the above examples
    };
  }

  put this into your .bashrc
    loadEnv(){ . "${HOME}/.nix-profile/dev-envs/${1}"; }

  afterwards execute the new bash shell:
    $ bash

  the nix expression created is called: env-mytestenv and must appear when searching for it using:
    $ nix-env -qa '*' | grep nix
      env-mytestenv

  now we should build our newly defined custom environment using this command on a shell, so type:
    $ nix-env -iA env-mytestenv

  afterwards load the new environment using:
    $ loadEnv mytestenv
  one could also use this function instead:
    $ load-mytestenv-env
  the result using either command should be:
    env-mytestenv loaded

  note: after you typed the above command you will lose all the other tools usually found in a shell you are used to. in this
        example you will not be able to type 'vi' to edit a file as vi is not included in the dependencies
*/

{ mkDerivation, substituteAll, pkgs } : { stdenv ? pkgs.stdenv, name, buildInputs ? [], cTags ? [], extraCmds ? ""} :
mkDerivation {
  # The setup.sh script from stdenv will expect the native build inputs in
  # the buildNativeInputs environment variable.
  buildNativeInputs = [ ] ++ buildInputs ;
  name = "env-${name}";
  phases = [ "buildPhase" "fixupPhase" ];
  setupNew = substituteAll {
    src = ../../stdenv/generic/setup.sh;
    initialPath= (import ../../stdenv/common-path.nix) { inherit pkgs; };
    gcc = stdenv.gcc;
  };

  buildPhase = ''
    set -x
    mkdir -p "$out/dev-envs" "$out/nix-support" "$out/bin"
    s="$out/nix-support/setup-new-modified"
    cp "$setupNew" "$s"
    # shut some warning up.., do not use set -e
    sed -e 's@set -e@@' \
        -e 's@assertEnvExists\s\+NIX_STORE@:@' \
        -e 's@trap.*@@' \
        -i "$s"
    cat >> "$out/dev-envs/''${name/env-/}" << EOF
      buildNativeInputs="$buildNativeInputs"
      # the setup-new script wants to write some data to a temp file.. so just let it do that and tidy up afterwards
      tmp="\$("${pkgs.coreutils}/bin/mktemp" -d)"
      NIX_BUILD_TOP="\$tmp"
      phases=
      # only do all the setup stuff in nix-support/*
      set +e
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
      rm -fr "\$tmp"
      ${extraCmds}
      export PATH
      echo $name loaded
    EOF

    cat >> "$out/bin/load-''${name/env-/}-env" << EOF
    #!/bin/sh

    source "$out/dev-envs/''${name/env-/}"
    EOF
    chmod +x "$out/bin/load-''${name/env-/}-env" 
  '';
}
