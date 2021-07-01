{ lib, fetchFromGitHub }:

let
  version = "3.7.11";
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
  sha256 = "sha256-hoYh2FdZGY/4/QmrqZubJYHP3bBcnUQFR9C7dfVTnWE=";

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
