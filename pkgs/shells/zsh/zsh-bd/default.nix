{ stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "zsh-bd";
  version = "2018-07-04";

  src = fetchFromGitHub {
    owner = "Tarrasch";
    repo = pname;
    rev = "d4a55e661b4c9ef6ae4568c6abeff48bdf1b1af7";
    sha256 = "020f8nq86g96cps64hwrskppbh2dapfw2m9np1qbs5pgh16z4fcb";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh-bd
    cp {.,$out/share/zsh-bd}/bd.zsh
    cd $out/share/zsh-bd
    ln -s bd{,.plugin}.zsh
  '';

  meta = {
    description = "Jump back to a specific directory, without doing `cd ../../..` ";
    homepage = "https://github.com/Tarrasch/zsh-bd";
    license = stdenv.lib.licenses.free;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.olejorgenb ];
  };
}
