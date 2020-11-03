{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "nix-build-uncached";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-build-uncached";
    rev = "v${version}";
    sha256 = "0hjx2gdwzg02fzxhsf7akp03vqj2s7wmcv9xfqn765zbqnljz14v";
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
