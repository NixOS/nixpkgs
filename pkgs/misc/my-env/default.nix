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
      nixEnv = simple {
       name = "nix";
       buildInputs = [ libtool stdenv perl curl bzip2 openssl aterm242fixes db45 autoconf automake zlib ];
       cTags = [ aterm242fixes];
      };
      [...]
    };
  }


  Put this into your .bashrc
    loadEnv(){ . "${HOME}/.nix-profile/dev-envs/${1}" }

  then nix-env -iA ...nixEnv
  and
  $ loadEnv postgresql

*/

{ mkDerivation, substituteAll, pkgs } : { stdenv ? pkgs.stdenv, name, buildInputs ? [], cTags ? [], extraCmds ? ""} :
mkDerivation {
  buildInputs = [ ] ++ buildInputs ;
  name = "env-${name}";
  phases = "buildPhase";
  setupNew = substituteAll {
    src = ../../stdenv/generic/setup-new.sh;
    preHook="";
    postHook="";
    initialPath= (import ../../stdenv/common-path.nix) { inherit pkgs; };
    gcc = stdenv.gcc;
  };
  buildPhase = ''
    set -x
    mkdir -p "$out/dev-envs" "$out/nix-support"
    s="$out/nix-support/setup-new-modified"
    cp "$setupNew" "$s"
    # shut some warning up.., do not use set -e
    sed -e 's@set -e@@' \
        -e 's@assertEnvExists\s\+NIX_STORE@:@' \
        -e 's@trap.*@@' \
        -i "$s"
    cat >> "$out/dev-envs/''${name/env-/}" << EOF
      buildInputs="$buildInputs"
      # the setup-new script wants to write some data to a temp file.. so just let it do that and tidy up afterwards
      tmp="\$("${pkgs.coreutils}/bin/mktemp" -d)"
      NIX_BUILD_TOP="\$tmp"
      phases=
      # only do all the setup stuff in nix-support/*
      set +e
      source "$s"
      rm -fr "\$tmp"
      ${extraCmds}
      export PATH
      echo $name loaded
    EOF
  '';
}
