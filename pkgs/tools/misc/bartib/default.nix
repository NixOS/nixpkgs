{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "bartib";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nikolassv";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ph3rsrhcyi272bv5018pw185zn7fvp5fqj24yh9rjrz8x7iawib";
  };

  cargoSha256 = "sha256-1ZFwX7NKIainer7o9dIMxwyycdGW8K9euLHad/tF95w=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd bartib --bash misc/bartibCompletion.sh
  '';

  meta = with lib; {
    description = "A simple timetracker for the command line";
    homepage = "https://github.com/nikolassv/bartib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "bartib";
  };
}
