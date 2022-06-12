{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "mmctl";
  version = "6.4.2";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mmctl";
    rev = "v${version}";
    sha256 = "sha256-FlqkY4LvAW9Cibs+3UkMDWA+uc62wMh13BllWuxjVZU=";
  };

  vendorSha256 = null;

  checkPhase = "make test";

  meta = with lib; {
    description = "A remote CLI tool for Mattermost";
    homepage = "https://github.com/mattermost/mmctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ ppom ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
