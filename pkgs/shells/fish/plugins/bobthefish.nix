{ lib
, buildFishPlugin
, fetchFromGitHub
,
}:
buildFishPlugin rec {
  pname = "bobthefish";
  version = "unstable-2022-08-02";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "theme-bobthefish";
    rev = "2dcfcab653ae69ae95ab57217fe64c97ae05d8de";
    sha256 = "sha256-jBbm0wTNZ7jSoGFxRkTz96QHpc5ViAw9RGsRBkCQEIU=";
  };

  meta = with lib; {
    description = "A Powerline-style, Git-aware fish theme optimized for awesome";
    homepage = "https://github.com/oh-my-fish/theme-bobthefish";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
