{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "peach";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "peachdocs";
    repo = "peach";
    rev = "v${version}";
    sha256 = "sha256-ctRE7aF3Qj+fI/m0CuLA6x7E+mY6s1+UfBJI5YFea4g=";
  };

  vendorSha256 = "sha256-T/KLiSK6bxXGkmVJ5aGrfHTUfLs/ElGyWSoCL5kb/KU=";

  meta = with lib; {
    description = "Web server for multi-language, real-time synchronization and searchable documentation";
    homepage = "https://peachdocs.org/";
    license = licenses.asl20;
    maintainers = [ maintainers.ivar ];
  };
}
