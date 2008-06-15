# idea: provide nix environment for your developement actions
# experimental

/*
  # example for nix itself adding glibc tag file to an env var.
  # experimental
  env_nix = my_environment rec {
   buildInputs = [perl curl bzip2 aterm242fixes db4] 
          ++ map (x : sourceWithTagsDerivation ( (addCTaggingInfo x ).passthru.sourceWithTags ) ) [ glibc ];
   db4 = db44;
   aterm = aterm242fixes;
   name = "env_nix";
   userCmds = ". ~/.bashrc
    PS1='\033]2;\h:\u:\w\007\\nenv ${name} \[\033[1;32m\][\u@\h: \w ]$\[\033[0m\] '
     ";
  };
Put this into your .bashrc
loadEnv(){
  . "${HOME}/.nix-profile/dev-envs/${1}"
}
*/

args: args.stdenv.mkDerivation ( 
  { extraCmds =""; } // {
  phases = "buildPhase";
  buildPhase = ''
    name=${args.name}
    o=$out/dev-envs/$name
    ensureDir `dirname $o`
    echo "
    OLDPATH=\$PATH " >> $o
    export | grep -v HOME= | grep -v PATH= | grep -v PWD= | grep -v TEMP= | grep -v TMP= >> $o 
    echo "
    PATH=$PATH:$OLDPATH
    for i in \$buildInputs; do
      export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$i/lib
    done
    export PATH=\$PATH:\$OLDPATH
    $extraCmds
    echo env $name loaded
    " >> $o
    chmod +x $o
  '';
} // args // { name = "${args.name}-env"; } )
