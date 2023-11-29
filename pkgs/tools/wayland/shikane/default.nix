{ lib
, rustPlatform
, fetchFromGitLab
, installShellFiles
, pandoc
}:

rustPlatform.buildRustPackage rec {
  pname = "shikane";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "w0lff";
    repo = "shikane";
    rev = "v${version}";
    hash = "sha256-S55elFZQT234fKlISFi21QJtnf2yB0O2u2vSNFhzgBg=";
  };

  cargoHash = "sha256-4wisXVaZa2GBFKywl48beQgg4c+lawL3L/837ZU1Y94=";

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
