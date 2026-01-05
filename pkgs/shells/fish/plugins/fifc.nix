{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin rec {
  pname = "fifc";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "gazorby";
    repo = "fifc";
    rev = "v${version}";
    hash = "sha256-p5E4Mx6j8hcM1bDbeftikyhfHxQ+qPDanuM1wNqGm6E=";
  };

  meta = with lib; {
    description = "Fzf powers on top of fish completion engine and allows customizable completion rules";
    homepage = "https://github.com/gazorby/fifc";
    license = licenses.mit;
    maintainers = with maintainers; [ hmajid2301 ];
  };
}
