{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "s5cmd";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "peak";
    repo = "s5cmd";
    rev = "v${version}";
    hash = "sha256-4Jx9hgjj+rthiyB7eKXNcbBv9oJWfwHanPO7bZ4J/K0=";
  };

  vendorHash = null;

  # Skip e2e tests requiring network access
  excludedPackages = [ "./e2e" ];

  meta = with lib; {
    homepage = "https://github.com/peak/s5cmd";
    description = "Parallel S3 and local filesystem execution tool";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
