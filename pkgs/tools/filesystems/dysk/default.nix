{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "dysk";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    rev = "v${version}";
    hash = "sha256-iagh4BrcfQY8k2u1HlR50ht/KWOeEkoxYJ/Lg2cKWX8=";
  };

  cargoHash = "sha256-mgEdDX+K71aT4ZMBDzxjOZhHqq8baXFFrwkfYzwIbUI=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage $releaseDir/build/*/out/dysk.1
    installShellCompletion $releaseDir/build/*/out/{dysk.bash,dysk.fish,_dysk}
  '';

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/dysk";
    changelog = "https://github.com/Canop/dysk/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda koral ];
  };
}
