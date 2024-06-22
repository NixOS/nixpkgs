{ lib, fetchFromGitHub }:

let
  version = "3.14.84";
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
  hash = "sha256-tahf6mdtmZofwMZfMsuDAqCR/V1qZt6vV+o6t4YTKG0=";

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
