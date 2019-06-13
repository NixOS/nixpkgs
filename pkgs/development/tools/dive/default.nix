{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dive";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = pname;
    rev = "v${version}";
    sha256 = "0az9b800zwk5sd90s8ssg8amf0a4dl7nrglkirp51d8hh3rs6nzl";
  };

  modSha256 = "1rc9nqri66kgjpxqcgwllyd0qmk46gs3wmsfdj1w43p6ybnaf3qw";

  meta = with lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = https://github.com/wagoodman/dive;
    license = licenses.mit;
    maintainers = with maintainers; [ marsam spacekookie ];
  };
}
