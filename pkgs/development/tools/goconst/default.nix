{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goconst";
  version = "1.5.1";

  excludedPackages = [ "tests" ];

  src = fetchFromGitHub {
    owner = "jgautheron";
    repo = "goconst";
    rev = "v${version}";
    sha256 = "sha256-chBWxOy9V4pO3hMaeCoKwnQxIEYiSejUOD3QDBCpaoE=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Find in Go repeated strings that could be replaced by a constant";
    homepage = "https://github.com/jgautheron/goconst";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
