{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "flitter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "alexozer";
    repo = "flitter";
    rev = "v${version}";
    sha256 = "sha256-XyHUUuENnGmIUlfYl7+NuSP115+sZfjXtd4bEIZQpf8=";
  };

  cargoHash = "sha256-ydYBHC/LxdYGA1+eYLTSZdkOhAgkw99J9JVT5micgdg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xorg.libX11
  ];

  meta = with lib; {
    description = "Livesplit-inspired speedrunning split timer for Linux/macOS terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    homepage = "https://github.com/alexozer/flitter";
    platforms = platforms.unix;
    mainProgram = "flitter";
    broken = stdenv.isDarwin;
  };
}
