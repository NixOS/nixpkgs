{ lib, fetchFromGitHub }:

let
  version = "3.14.82";
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
  hash = "sha256-FS9+w+9QPBd6hCtX7C5x/xm4nGCA0lOtYgjefkQNbbg=";

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [
      moni
      Guanran928
      frontear
    ];
  };
}
