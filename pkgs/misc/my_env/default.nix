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
*/

args:  stdenv.mkDerivation ( 
  { userCmds =""; } // {
  phases = "buildPhase";
  buildPhase = "
    ensureDir \$out/bin
    name=${args.name}
    o=\$out/bin/$name
    echo -e \"#!/bin/sh --login\\n\" >> \$o
    export | grep -v HOME= | grep -v PATH= >> \$o 
    echo \"export PATH=\$PATH:\\\$PATH entering $name\" >> \$o
    echo \"echo entering $name\" >> \$o
    echo \"$userCmds\" >> \$o
    echo \"/bin/sh\" >> $o
    echo \"echo leaving $name\" >> \$o
    chmod +x $o
  ";
} //args);
