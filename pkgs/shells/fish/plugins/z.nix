{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "z";
  version = "0-unstable-2022-04-08";

  src = fetchFromGitHub {
    owner = "jethrokuan";
    repo = "z";
    rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
    sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
  };

  meta = {
    description = "Pure-fish z directory jumping";
    homepage = "https://github.com/jethrokuan/z";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
}
