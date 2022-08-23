{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fsql";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "kshvmdn";
    repo = "fsql";
    rev = "v${version}";
    sha256 = "sha256-/9X1ag18epFjEfB+TbRsHPCZRZblV0ohvDlZ523kXXc=";
  };

  vendorSha256 = "sha256-h75iQSpHZqc0QNOZWHU1l6xsHB8ClfWXYo1jVMzX72Q=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Search through your filesystem with SQL-esque queries";
    homepage = "https://github.com/kshvmdn/fsql";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
