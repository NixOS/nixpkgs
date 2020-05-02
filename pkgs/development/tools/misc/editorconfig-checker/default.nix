{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "editorconfig-checker";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = "${version}";
    sha256 = "1y90yz8da0iqig3m0kbjcicwblkirbbx0s3agpmz2pdca6y2ijwi";
  };

  vendorSha256 = "1lyrqrm3pyfv470dmymbkb3vpvp0i2zsndp7qw34fbhp2gnay5kh";

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [ "-ldflags=-X main.version=${version}" ];

  postInstall = ''
    installManPage docs/editorconfig-checker.1
  '';

  meta = with lib; {
    description = "A tool to verify that your files are in harmony with your .editorconfig";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva ];
  };
}
