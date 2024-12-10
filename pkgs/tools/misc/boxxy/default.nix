{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "boxxy";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "queer";
    repo = "boxxy";
    rev = "v${version}";
    hash = "sha256-euIecFMDktL0gDkso83T1qZfVdfYAAC+WBMsfZaarAQ=";
  };

  cargoHash = "sha256-8aIuMRjZHLlP3x+C9S9WX21/i98RAUvGGwzptzCpRR4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = with lib; {
    description = "Puts bad Linux applications in a box with only their files";
    homepage = "https://github.com/queer/boxxy";
    license = licenses.mit;
    maintainers = with maintainers; [
      dit7ya
      figsoda
    ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
    mainProgram = "boxxy";
  };
}
