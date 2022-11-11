{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kcli";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "cswank";
    repo = "kcli";
    rev = version;
    sha256 = "0whijr2r2j5bvfy8jgmpxsa0zvwk5kfjlpnkw4za5k35q7bjffls";
  };

  vendorSha256 = "0zj2hls8m0l9xsfv680wiwq1g2qjdjslv2yx3yd4rzxdsv2wz09a";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A kafka command line browser";
    homepage = "https://github.com/cswank/kcli";
    license = licenses.mit;
    maintainers = with maintainers; [ cswank ];
  };
}
