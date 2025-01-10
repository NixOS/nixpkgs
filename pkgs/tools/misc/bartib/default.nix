{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "bartib";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nikolassv";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eVLacxKD8seD8mxVN1D3HhKZkIDXsEsSisZnFbmhpSk=";
  };

  cargoSha256 = "sha256-s/oGv7/0LgNpdGu6dnvvbxDgFDvcvcHL01dSPxhMVWE=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd bartib --bash misc/bartibCompletion.sh
  '';

  meta = with lib; {
    description = "Simple timetracker for the command line";
    homepage = "https://github.com/nikolassv/bartib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "bartib";
  };
}
