{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tcat";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "rsc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1szzfz5xsx9l8gjikfncgp86hydzpvsi0y5zvikd621xkp7g7l21";
  };
  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";
  subPackages = ".";

  meta = with lib; {
    description = "Table cat";
    homepage = "https://github.com/rsc/tcat";
    maintainers = with maintainers; [ mmlb ];
    license = licenses.bsd3;
  };
}
