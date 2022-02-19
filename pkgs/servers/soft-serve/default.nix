{ lib, buildGoModule, fetchFromGitHub, makeWrapper, git }:

buildGoModule rec {
  pname = "soft-serve";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    rev = "v${version}";
    sha256 = "sha256-vminGN8GKw0qn+U9IQ+o6BT4mhOpoS/mpuroO50dEII=";
  };

  vendorSha256 = "sha256-m5xwxs6XvmPffDX9dkkEG0/LdlDDm6Eq9CC0tVdauVI=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/soft \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  meta = with lib; {
    description = "A tasty, self-hosted Git server for the command line";
    homepage = "https://github.com/charmbracelet/soft-serve";
    mainProgram = "soft";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
