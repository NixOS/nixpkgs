{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "bobthefisher";
  version = "0-unstable-2023-10-25";

  src = fetchFromGitHub {
    owner = "Scrumplex";
    repo = "bobthefisher";
    rev = "f4179a14b087c7fbfc2e892da429adad40a39e44";
    sha256 = "sha256-l1DHSZa40BX2/4GCjm5E53UOeFEnMioWbZtCW14WX6k=";
  };

  meta = with lib; {
    description = "Powerline-style, Git-aware fish theme optimized for awesome (fork of bobthefish)";
    homepage = "https://github.com/Scrumplex/bobthefisher";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
