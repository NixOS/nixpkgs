{ lib, fetchFromGitHub }:

let
  version = "3.7.9";
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
  sha256 = "sha256-5PhJ48w/dNmSgc3XUaFUhVWyvH7jSUj8moBM3Yvmrz4=";

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
