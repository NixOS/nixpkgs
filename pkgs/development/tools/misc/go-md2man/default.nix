{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-md2man";
  version = "2.0.2";

  vendorSha256 = null;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cpuguy83";
    repo = "go-md2man";
    sha256 = "sha256-C+MaDtvfPYABSC2qoMfZVHe2xX/WtDjp6v/ayFCIGac=";
  };

  meta = with lib; {
    description = "Go tool to convert markdown to man pages";
    license = licenses.mit;
    homepage = "https://github.com/cpuguy83/go-md2man";
    maintainers = with maintainers; [offline];
  };
}
