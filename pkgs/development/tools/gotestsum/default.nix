{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "sha256-5iSUk/J73enbc/N3bn7M4oj2A0yoF1jTWpnXD380hFI=";
  };

  vendorSha256 = "sha256-sHi8iW+ZV/coeAwDUYnSH039UNtUO9HK0Bhz9Gmtv8k=";

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
