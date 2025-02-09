{ lib, fetchFromGitHub }:

let
  version = "3.13.10";
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
  sha256 = "sha256-LTo0NV1DpHI05AvfmTKNz+/NdXaNoLxgpMhV/HqeT6g=";

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [ moni ];
  };
}
