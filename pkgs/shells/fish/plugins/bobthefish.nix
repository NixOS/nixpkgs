{ lib
, buildFishPlugin
, fetchFromGitHub
,
}:
buildFishPlugin {
  pname = "bobthefish";
  version = "unstable-2023-06-16";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "theme-bobthefish";
    rev = "c2c47dc964a257131b3df2a127c2631b4760f3ec";
    sha256 = "sha256-LB4g+EA3C7OxTuHfcxfgl8IVBe5NufFc+5z9VcS0Bt0=";
  };

  meta = with lib; {
    description = "Powerline-style, Git-aware fish theme optimized for awesome";
    homepage = "https://github.com/oh-my-fish/theme-bobthefish";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
