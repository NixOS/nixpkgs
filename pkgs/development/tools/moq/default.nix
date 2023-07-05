{ stdenv, buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "moq";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "matryer";
    repo = "moq";
    rev = "v${version}";
    sha256 = "sha256-T+vBzhc9XafCeXsW4/24vOn4U7N1t0S8DXkPNav7I94=";
  };

  vendorHash = "sha256-lfs61YK5HmUd3/qA4o9MiWeTFhu4MTAkNH+f0iGlRe0=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/matryer/moq";
    description = "Interface mocking tool for go generate";
    longDescription = ''
      Moq is a tool that generates a struct from any interface. The struct can
      be used in test code as a mock of the interface.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ anpryl ];
  };
}
