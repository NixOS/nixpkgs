{ lib, fetchFromGitHub }:

let
  version = "3.7.6";
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
  sha256 = "sha256-zjUdHzsjv16PHXfxTuVC6aNKfh+73dH1AABvq1MArXI=";

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
