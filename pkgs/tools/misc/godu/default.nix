{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "godu";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "viktomas";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fJeSUAuNELZZ1DcybNsYd2ZX93VYWsLum5tHp68ZVlo=";
  };

  vendorHash = "sha256-8cZCeZ0gqxqbwB0WuEOFmEUNQd3/KcLeN0eLGfWG8BY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Utility helping to discover large files/folders";
    homepage = "https://github.com/viktomas/godu";
    license = licenses.mit;
    maintainers = with maintainers; [ rople380 ];
  };
}
