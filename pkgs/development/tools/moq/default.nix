{ stdenv, buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "moq";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "matryer";
    repo = "moq";
    rev = "v${version}";
    sha256 = "sha256-HJAfTTmsVIz/2gZxl5Sw+OMh6I6bjpZGd1afIjBWtXo=";
  };

  vendorHash = "sha256-2C5p2JTTCADGRsf0BMuxpQXk+25Q1YI25SSVE/5uZ1A=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/matryer/moq";
    description = "Interface mocking tool for go generate";
    mainProgram = "moq";
    longDescription = ''
      Moq is a tool that generates a struct from any interface. The struct can
      be used in test code as a mock of the interface.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ anpryl ];
  };
}
