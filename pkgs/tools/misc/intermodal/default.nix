{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "intermodal";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yPyKo2j0Up8gDzi2xOBqpMwIw6rpXDCxc8fCuEblwFY=";
  };

  cargoHash = "sha256-inJZTP4YwCZZ0JvSdGWnZbLN0A0B/+fz4g0XsfIQeq8=";

  # include_hidden test tries to use `chflags` on darwin
  checkFlagsArray = lib.optionals stdenv.isDarwin [ "--skip=subcommand::torrent::create::tests::include_hidden" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd imdl \
      --bash <($out/bin/imdl completions bash) \
      --fish <($out/bin/imdl completions fish) \
      --zsh  <($out/bin/imdl completions zsh)
  '';

  meta = with lib; {
    description = "User-friendly and featureful command-line BitTorrent metainfo utility";
    homepage = "https://github.com/casey/intermodal";
    license = licenses.cc0;
    maintainers = with maintainers; [ Br1ght0ne xrelkd ];
    mainProgram = "imdl";
  };
}
