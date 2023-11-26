{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-md2man";
  version = "2.0.3";

  vendorHash = null;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cpuguy83";
    repo = "go-md2man";
    sha256 = "sha256-bgAuN+pF9JekCQ/Eg4ph3WDv3RP8MB/10GDp1JMp9Kg=";
  };

  meta = with lib; {
    description = "Go tool to convert markdown to man pages";
    license = licenses.mit;
    homepage = "https://github.com/cpuguy83/go-md2man";
    maintainers = with maintainers; [offline];
  };
}
