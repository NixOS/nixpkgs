{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "sha256-/DpsB3MS0iPYFSug3RTWOprB8tclVP6v3dbS3mC3S+g=";
  };

  vendorSha256 = "sha256-AOdWv0PkDi8o5V71DVzAd/sRibbMf3CkqmJGmuxHtuc=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/gotestyourself/gotestsum";
    description = "A human friendly `go test` runner";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
  };
}
