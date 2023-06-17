{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "boxxy";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "queer";
    repo = "boxxy";
    rev = "v${version}";
    hash = "sha256-cXEoY9+no+WSp/VbbKl6q/mV5+B5d54kuIRfTtQUFc4=";
  };

  cargoHash = "sha256-PiX10Q3tYkVcbj3SX5MkaN1xQ/H7SCNpqTIgG+nJ6uo=";

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
    maintainers = with maintainers; [ dit7ya figsoda ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
