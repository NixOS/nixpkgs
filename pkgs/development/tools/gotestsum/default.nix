{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "sha256-22srQmvbVu8eWVAbLDZG93yod/bJS6hfoc/YwFs64pY=";
  };

  vendorHash = "sha256-zUqa6xlDV12ZV4N6+EZ7fLPsL8U+GB7boQ0qG9egvm0=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X gotest.tools/gotestsum/cmd.version=${version}" ];

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/gotestyourself/gotestsum";
    description = "A human friendly `go test` runner";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
  };
}
