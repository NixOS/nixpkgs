{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, oniguruma
}:

rustPlatform.buildRustPackage rec {
  pname = "boxxy";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "queer";
    repo = "boxxy";
    rev = "v${version}";
    hash = "sha256-c1AZz5WwSie0lenH0LoPOvR4VWd7pYd59WWmjFn6HiQ=";
  };

  cargoHash = "sha256-840W5wyOV+nTr9HzftOUlUwZ1JRe7+FWTG4Q2L+yCXM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  RUSTONIG_SYSTEM_LIBONIG = true;

  meta = with lib; {
    description = "Puts bad Linux applications in a box with only their files";
    homepage = "https://github.com/queer/boxxy";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya figsoda ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
