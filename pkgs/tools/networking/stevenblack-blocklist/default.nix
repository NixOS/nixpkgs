{ lib, fetchFromGitHub }:

let
  version = "3.7.13";
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
  sha256 = "sha256-nSajiRDpcFp3MwnQPnoBVB/OWnhVqkeSmS7OBrfhMnw=";

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
