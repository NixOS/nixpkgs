{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yq-go";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "mikefarah";
    rev = version;
    repo = "yq";
    sha256 = "0gjxmnmphav8ms4zdkcjcsgrjs77ccwdfpc1qpxjp6fr2g4v5vmq";
  };

  modSha256 = "035w9bh96rr2x21w7bwwpngyng6839wglpgwf7gy8p6difvnn2v9";

  meta = with stdenv.lib; {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    license = [ licenses.mit ];
    maintainers = [ maintainers.lewo ];
  };
}
