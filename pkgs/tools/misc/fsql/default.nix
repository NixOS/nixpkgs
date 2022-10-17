{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fsql";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "kshvmdn";
    repo = "fsql";
    rev = "v${version}";
    sha256 = "sha256-YavkN7n2Nt92T+uMwWRVv3q81DA6fFoNIJt9NYMS3rc=";
  };

  vendorSha256 = "sha256-xuD7/gTssf1Iu1VuIRysjtUjve16gozOq0Wz4w6mIB8=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Search through your filesystem with SQL-esque queries";
    homepage = "https://github.com/kshvmdn/fsql";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
