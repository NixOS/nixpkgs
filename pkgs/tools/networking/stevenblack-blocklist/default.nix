{ lib, fetchFromGitHub }:

let
  version = "3.14.44";
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
  sha256 = "sha256-LlTyhtx3DbtsQdkl6J7ktj/zLJULFqQWq5sCqKPX71g=";

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [ moni ];
  };
}
