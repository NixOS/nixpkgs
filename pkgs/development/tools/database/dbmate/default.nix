{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dbmate";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "1q1hyrd1zlynyb0720fd1lwg22l3bwjbcak2aplh259p698gwyf5";
  };

  vendorSha256 = "197zpjvvv9xpfbw443kbxvhjmjqmx1h2bj1xl2vwgf0w64mkk84z";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}
