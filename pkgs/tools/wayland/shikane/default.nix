{ lib
, rustPlatform
, fetchFromGitLab
, installShellFiles
, pandoc
}:

rustPlatform.buildRustPackage rec {
  pname = "shikane";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "w0lff";
    repo = "shikane";
    rev = "v${version}";
    hash = "sha256-Chc1+JUHXzuLl26NuBGVxSiXiaE4Ns1FXb0dBs6STVk=";
  };

  cargoHash = "sha256-uuQBTAyWczzc4Ez2Tq4Ps6NPonXqHrXAP2AZFzgsvo4=";

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  postBuild = ''
    bash ./scripts/build-docs.sh man
  '';

  postInstall = ''
    installManPage ./build/shikane.*
  '';

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "A dynamic output configuration tool that automatically detects and configures connected outputs based on a set of profiles";
    homepage = "https://gitlab.com/w0lff/shikane";
    changelog = "https://gitlab.com/w0lff/shikane/-/tags/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ michaelpachec0 natsukium ];
    platforms = platforms.linux;
    mainProgram = "shikane";
  };
}
