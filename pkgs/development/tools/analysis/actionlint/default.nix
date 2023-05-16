{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, python3Packages
, ronn
, shellcheck
}:

buildGoModule rec {
  pname = "actionlint";
<<<<<<< HEAD
  version = "1.6.25";
=======
  version = "1.6.24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "actionlint";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-MbMisADJg0c0idAZ3Ru1WJMzbYoyac71CIeQd3Xjsy0=";
  };

  vendorHash = "sha256-YkLZYL+VgO2QfkjVG3baPCn+CExRnsnxtdmL3GGNGlI=";
=======
    hash = "sha256-aUUHXI3D55bS6RYWNoia4xp80UYR2vz5GUWAdaqjnNk=";
  };

  vendorHash = "sha256-GtnTzFL6nuUmHAFChIjI6dxzsva/3Ob96DS2iCinlKE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ makeWrapper ronn installShellFiles ];

  postInstall = ''
    ronn --roff man/actionlint.1.ronn
    installManPage man/actionlint.1
    wrapProgram "$out/bin/actionlint" \
      --prefix PATH : ${lib.makeBinPath [ python3Packages.pyflakes shellcheck ]}
  '';

  ldflags = [ "-s" "-w" "-X github.com/rhysd/actionlint.version=${version}" ];

  meta = with lib; {
    homepage = "https://rhysd.github.io/actionlint/";
    description = "Static checker for GitHub Actions workflow files";
    changelog = "https://github.com/rhysd/actionlint/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    mainProgram = "actionlint";
  };
}
