{ lib, fetchFromGitHub }:

let
  version = "3.9.39";
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
  sha256 = "sha256-ONBq6ZHRI6fonL+Q/6ajFhbfHMq7toL8cALltK5c3Kc=";

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
