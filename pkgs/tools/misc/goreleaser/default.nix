{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "0.132.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "1iwxlvwsmasp8gq1yh84hl9rys0hgm9fwpmsqh2mx9ln4prm7sgq";
  };

  modSha256 = "0a4qr8xsi4szggvzapw2ljvvvqjbyi15i4mi8myfhknlpxf65kcl";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Deliver Go binaries as fast and easily as possible";
    homepage = "https://goreleaser.com";
    maintainers = [ maintainers.c0deaddict ];
    license = licenses.mit;
  };
}
