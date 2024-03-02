{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "sdkman-for-fish";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "reitzig";
    repo = "sdkman-for-fish";
    rev = "v${version}";
    hash = "sha256-cgDTunWFxFm48GmNv21o47xrXyo+sS6a3CzwHlv0Ezo=";
  };

  meta = with lib; {
    description = "Adds support for SDKMAN! to fish";
    homepage = "https://github.com/reitzig/sdkman-for-fish";
    license = licenses.mit;
    maintainers = with maintainers; [ giorgiga ];
  };
}
