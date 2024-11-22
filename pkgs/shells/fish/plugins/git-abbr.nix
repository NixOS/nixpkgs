{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin rec {
  pname = "fish-git-abbr";
  version = "0.2.1-unstable-2023-06-19";

  src = fetchFromGitHub {
    owner = "lewisacidic";
    repo = "fish-git-abbr";
    rev = "dc590a5b9d9d2095f95f7d90608b48e55bea0b0e";
    hash = "sha256-6z3Wr2t8CP85xVEp6UCYaM2KC9PX4MDyx19f/wjHkb0=";
  };

  meta = with lib; {
    description = "Abbreviations for git for the fish shell 🐟";
    homepage = "https://github.com/lewisacidic/fish-git-abbr";
    license = licenses.mit;
    maintainers = with maintainers; [hmajid2301];
  };
}
