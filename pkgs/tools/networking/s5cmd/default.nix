{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "s5cmd";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "peak";
    repo = "s5cmd";
    rev = "v${version}";
    sha256 = "sha256-9G0GSMNLYeIrbq7zctM3OCRcEZF1giEt+u5g3lTX96M=";
  };

  vendorSha256 = null;

  meta = with lib; {
    homepage = "https://github.com/peak/s5cmd";
    description = "Parallel S3 and local filesystem execution tool";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
