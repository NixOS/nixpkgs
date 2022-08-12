{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-WpSF3HnSjCqUkD1PVvtYXoWSyjYnasr85AK8wMULPBI=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-8NhZD7ImvsBGw0xi9NR7AB9SdHkwjsA+jV7UTjVF4wM=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 rski SuperSandro2000 zimbatm ];
  };
}
