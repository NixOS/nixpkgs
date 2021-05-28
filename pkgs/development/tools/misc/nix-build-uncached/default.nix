{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "nix-build-uncached";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-build-uncached";
    rev = "v${version}";
    sha256 = "106k4234gpi8mr0n0rfsgwk4z7v0b2gim0r5bhjvg2v566j67g02";
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
