{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.12.14";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    sha256 = "sha256-+qFR5XGV1LSCY8AR7gd269UcOwlL5hkvKiQEhdsqIJc=";
  };

  vendorSha256 = "sha256-2ABWPqhK2Cf4ipQH7XvRrd+ZscJhYPc3SV2cGT0apdg=";

  meta = with lib; {
    description = "An extremely fast JavaScript bundler";
    homepage = "https://esbuild.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ lucus16 ];
  };
}
