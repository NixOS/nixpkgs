{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "asouldocs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "asoul-sig";
    repo = "asouldocs";
    rev = "v${version}";
    hash = "sha256-ctRE7aF3Qj+fI/m0CuLA6x7E+mY6s1+UfBJI5YFea4g=";
  };

  vendorSha256 = "sha256-T/KLiSK6bxXGkmVJ5aGrfHTUfLs/ElGyWSoCL5kb/KU=";

  meta = with lib; {
    description = "Web server for multi-language, real-time synchronization and searchable documentation";
    homepage = "https://asouldocs.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ ivar ];
  };
}
