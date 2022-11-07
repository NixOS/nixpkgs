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

  proxyVendor = true; # fix vendor with go > 1.17, should be able to remove when package is bumped
  vendorSha256 = "sha256-kRno4SheBMhp59AOP9fL7cp+AllAS9jE8hpXUq694QQ=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A kafka command line browser";
    homepage = "https://github.com/cswank/kcli";
    license = licenses.mit;
    maintainers = with maintainers; [ cswank ];
  };
}
