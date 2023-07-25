{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "s5cmd";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "peak";
    repo = "s5cmd";
    rev = "v${version}";
    hash = "sha256-uH6KE3sTPc2FfqOxr6cB3A8DOq+VjGsJ3KoK8riOKXk=";
  };

  vendorSha256 = null;

  # Skip e2e tests requiring network access
  excludedPackages = [ "./e2e" ];

  meta = with lib; {
    homepage = "https://github.com/peak/s5cmd";
    description = "Parallel S3 and local filesystem execution tool";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
