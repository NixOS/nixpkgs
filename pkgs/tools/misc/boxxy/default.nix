{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, oniguruma
}:

rustPlatform.buildRustPackage rec {
  pname = "boxxy";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "queer";
    repo = "boxxy";
    rev = "v${version}";
    hash = "sha256-OUnvjn58jVMg4wYwoSMsqQvy5yveF+KeRjkjvB1W/Q4=";
  };

  cargoHash = "sha256-UhtxvEK3hknBdLS1eOlEPng+THoPuhYGIFhYz4LpF5E=";

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
