{ stdenv, fetchFromGitHub, rustPlatform, fzf }:

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "0s0zrkn48rgsf2fqpgsl0kix4l6w7k7pwssvdja6y3a4c097qmnm";
  };

  buildInputs = [
    fzf
  ];

  cargoSha256 = "1p65ml2qj5dpc6nczfvf341fk7y4yi5ma1x6kfr3d32wnv6m4hgh";

  meta = with stdenv.lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr ];
    platforms = platforms.all;
  };
}
