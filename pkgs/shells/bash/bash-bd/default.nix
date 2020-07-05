{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "bash-bd";
  version = "1.02";

  src = fetchFromGitHub {
    owner = "vigneshwaranr";
    repo = "bd";
    rev = "c497fe7d85ec13e75c087a0fc64e67eeb4a24b0c";
    sha256 = "09hrnl3cik9b1saz9awf96havdlxlgd7gyqil9dzl7ml2xl7hrc1";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/etc/bash_completion.d
    cp {$src,$out/etc}/bash_completion.d/bd
    cp {$src,$out/bin}/bd
  '';

  meta = {
    description = "Quickly go back to a specific parent directory in bash instead of typing `cd ../../..` redundantly";
    homepage = "https://github.com/vigneshwaranr/bd";
    license = stdenv.lib.licenses.mit;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.adamse ];
  };
}

