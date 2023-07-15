{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fsql";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "kshvmdn";
    repo = "fsql";
    rev = "v${version}";
    sha256 = "sha256-6KqlpFBaAWrlEjkFQhOEic569+eoYVAsnhMrg8AEPV4=";
  };

  vendorSha256 = "sha256-xuD7/gTssf1Iu1VuIRysjtUjve16gozOq0Wz4w6mIB8=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Search through your filesystem with SQL-esque queries";
    homepage = "https://github.com/kshvmdn/fsql";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
  };
}
