{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-md2man";
  version = "2.0.1";

  vendorSha256 = null;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cpuguy83";
    repo = "go-md2man";
    sha256 = "sha256-DnXWnHWtczNnLaQg9Wnp9U/K4h/FbhqGgba44P6VNBQ=";
  };

  meta = with lib; {
    description = "Go tool to convert markdown to man pages";
    license = licenses.mit;
    homepage = "https://github.com/cpuguy83/go-md2man";
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
