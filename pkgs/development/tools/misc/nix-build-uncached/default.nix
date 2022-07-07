{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "nix-build-uncached";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-build-uncached";
    rev = "v${version}";
    sha256 = "sha256-9oc5zoOlwV02cY3ek+qYLgZaFQk4dPE9xgF8mAePGBI=";
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
