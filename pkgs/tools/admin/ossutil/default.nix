{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  version = "1.7.16";
  pname = "ossutil";

  src = fetchFromGitHub {
    owner = "aliyun";
    repo = "ossutil";
    rev = "refs/tags/v${version}";
    hash = "sha256-J6t8QoyCvbGrUX2AkdqugztchP7Cc0jZsrn1+OB2hVY=";
  };

  vendorHash = "sha256-oxhi27Zt91S2RwidM+BPati/HWuP8FrZs1X2R2Px5hI=";

  # don't run tests as they require secret access keys that only travis has
  doCheck = false;

  meta = with lib; {
    description = "A user friendly command line tool to access Alibaba Cloud OSS";
    homepage = "https://github.com/aliyun/ossutil";
    changelog = "https://github.com/aliyun/ossutil/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
