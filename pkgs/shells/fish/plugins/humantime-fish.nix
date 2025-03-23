{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  fishtape,
}:
buildFishPlugin {
  pname = "humantime-fish";
  version = "1.0.0-unstable-2022-04-08";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "humantime.fish";
    rev = "53b2adb4c6aff0da569c931a3cc006efcd0e7219";
    sha256 = "sha256-792rPsf2WDIYcP8gn6TbHh9RZvskfOAL/oKfpilaLh0=";
  };

  checkPlugins = [ fishtape ];
  checkPhase = ''
    fishtape tests/humantime.fish
  '';

  meta = with lib; {
    description = "Turn milliseconds into a human-readable string in Fish";
    homepage = "https://github.com/jorgebucaran/humantime.fish";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
