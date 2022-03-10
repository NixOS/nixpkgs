{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dbmate";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "sha256-CgThS10mDYRj/VdVJeeVTMEbhvLLpWBweQ4dvo3k3Hg=";
  };

  vendorSha256 = "sha256-cbMCGC78vc61F4cEobarMPwVts2V3NkH4/CnHGeLd/o=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}
