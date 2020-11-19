{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "nix-build-uncached";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-build-uncached";
    rev = "v${version}";
    sha256 = "1v9xyv0hhvfw61k4pbgzrlgy7igl619cangi40fkh7gdvs01dxz4";
  };

  vendorSha256 = null;

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "A CI friendly wrapper around nix-build";
    license = licenses.mit;
    homepage = "https://github.com/Mic92/nix-build-uncached";
    maintainers = [ maintainers.mic92 ];
    platforms = platforms.unix;
  };
}
