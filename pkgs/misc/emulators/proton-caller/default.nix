{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "proton-caller";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "caverym";
    repo = pname;
    rev = "version";
    sha256 = "0968pmapg6157q4rvfp690l1sjnws8hm62lvm8kaaqysac339z7z";
  };

  cargoSha256 = "1vp2vvgy8z350a59k1c3s5ww6w2wikiha4s7jkkz9khl0spn19a8";

  nativeBuildInputs = [ installShellFiles ];

  outputs = [ "out" "man" ];

  postInstall = ''
    installManPage manual/proton-call.6
  '';

  meta = with lib; {
    description = "Run Windows programs with Proton";
    changelog = "https://github.com/caverym/proton-caller/releases/tag/${version}";
    homepage = "https://github.com/caverym/proton-caller";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kho-dialga ];
  };
}
