{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "editorconfig-checker";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = "${version}";
    sha256 = "0v2ml9r8b5admi3sv80wa1pwl9qnz03q2p84vgcmgg2nv1v6yxf3";
  };

  modSha256 = "09b1v9gyh6827yqlfxxxq3lcqhd5snn3n7gdlbjmga3wyp2x4g2r";

  meta = with lib; {
    description = "A tool to verify that your files are in harmony with your .editorconfig";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva ];
  };
}
