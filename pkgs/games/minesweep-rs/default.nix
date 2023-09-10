{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "minesweep-rs";
  version = "6.0.29";

  src = fetchFromGitHub {
    owner = "cpcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PgZ9fL+g2X3CddPVD/JRrIFbw7GS73ELD3EhhR9BAUc=";
  };

  cargoHash = "sha256-c06TfslXGAshR1HXz6PCI26DMpFsb6OrzQ38p4RgsAw=";

  meta = with lib; {
    description = "Sweep some mines for fun, and probably not for profit";
    homepage = "https://github.com/cpcloud/minesweep-rs";
    license = licenses.asl20;
    mainProgram = "minesweep";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
  };
}
