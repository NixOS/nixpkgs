{ lib, fetchFromGitHub }:

let
  version = "3.14.79";
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
  hash = "sha256-MfQGu+Y4/A0GKIu9d//U+yiP0fN/7cWhEo2dut4UvcE=";

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
