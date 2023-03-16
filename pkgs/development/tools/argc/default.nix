{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vvGeC+5dsO26ALfHoZ9+zVlpl+63Nj/VqtSBQo1Gl/c=";
  };

  cargoSha256 = "sha256-A45txIc5AcJtWx6Jl4w7Ys2H3UgTjRsEiMySuUv9+Ds=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion completions/argc.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "A tool to handle sh/bash cli parameters";
    homepage = "https://github.com/sigoden/argc";
    changelog = "https://github.com/sigoden/argc/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
