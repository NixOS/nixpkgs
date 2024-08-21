{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-edit";
  version = "unstable-2022-05-05";

  src = fetchFromGitHub {
    owner = "marlonrichert";
    repo = "zsh-edit";
    rev = "4a8fa599792b6d52eadbb3921880a40872013d28";
    sha256 = "PI4nvzB/F0mHlc0UZJdD49vjzB6pXhhJYNTSmBhY8iU=";
  };

  strictDeps = true;

  dontBuild = true;

  installPhase = ''
    outdir=$out/share/zsh/${pname}
    install -D zsh-edit.plugin.zsh $outdir/zsh-edit.plugin.zsh
    install -D _bind $outdir/_bind
    install -d $outdir/functions
    install -D functions/{,.edit}* $outdir/functions
  '';

  meta = with lib; {
    homepage = "https://github.com/marlonrichert/zsh-edit";
    description = "Set of powerful extensions to the Zsh command line editor";
    license = licenses.mit;
    maintainers = with maintainers; [ deejayem ];
    platforms = platforms.all;
  };
}
