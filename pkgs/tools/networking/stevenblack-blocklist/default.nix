{ lib, fetchFromGitHub }:

let
  version = "3.14.71";
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
  hash = "sha256-33aDL+nJ+BOwOOSfiaAX3r8BdDM2rWCaeiz55nUXrd8=";

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [
      moni
      Guanran928
    ];
  };
}
