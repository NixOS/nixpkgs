{ lib, stdenv, fetchFromGitHub, fzf, zsh-histdb }:

stdenv.mkDerivation rec {
  pname = "zsh-histdb-fzf";
  version = src.rev;

  src = fetchFromGitHub {
    owner = "m42e";
    repo = pname;
    rev = "055523a798acf02a67e242b3281d917f5ee4309a";
    sha256 = "sha256-5R6XImDVswD/vTWQRtL28XHNzqurUeukfLevQeMDpuY=";
  };

  strictDeps = true;
  dontBuild = true;

  buildInputs = [ fzf zsh-histdb ];

  installPhase = ''
    install -D -t $out/share/zsh/plugins/fzf-histdb/ fzf-histdb.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/m42e/zsh-histdb-fzf";
    license = licenses.mit;
    description = "uses fzf for searching the history kept with zsh-histdb.";
    maintainers = with maintainers; [ sielicki ];
  };
}
