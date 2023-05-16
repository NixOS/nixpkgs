{ stdenv, buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "moq";
<<<<<<< HEAD
  version = "0.3.2";
=======
  version = "0.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "matryer";
    repo = "moq";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-T+vBzhc9XafCeXsW4/24vOn4U7N1t0S8DXkPNav7I94=";
=======
    sha256 = "sha256-nareKBRPL7DVmclTqZCvImxXmHxXxbus1+U1QWCeSy0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
