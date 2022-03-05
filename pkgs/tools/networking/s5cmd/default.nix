{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "s5cmd";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "peak";
    repo = "s5cmd";
    rev = "v${version}";
    sha256 = "sha256-12bKMZ6SMPsqLqaBTVxCxvs7PZ0CKimI9wlqvWZ/bgY=";
  };

  vendorSha256 = null;

  meta = with lib; {
    homepage = "https://github.com/peak/s5cmd";
    description = "Parallel S3 and local filesystem execution tool";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
