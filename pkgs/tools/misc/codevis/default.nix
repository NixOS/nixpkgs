{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
}:

rustPlatform.buildRustPackage rec {
  pname = "codevis";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "sloganking";
    repo = "codevis";
    rev = "v${version}";
    hash = "sha256-K5rPeWP5xO46dvMaJ/bPvop5jKV6xEXF+iGzfKWWDvA=";
  };

  cargoHash = "sha256-M7EssXGbT1HuPmn2mf+xGrMNVzFigZy2DXeLMHPfUXM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  RUSTONIG_SYSTEM_LIBONIG = true;

  meta = with lib; {
    description = "A tool to take all source code in a folder and render them to one image";
    homepage = "https://github.com/sloganking/codevis";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
