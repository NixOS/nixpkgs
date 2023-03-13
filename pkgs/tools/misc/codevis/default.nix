{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
}:

rustPlatform.buildRustPackage rec {
  pname = "codevis";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "sloganking";
    repo = "codevis";
    rev = "v${version}";
    hash = "sha256-fnIZ3Ux9a47ix5EC/sqkAZMdMu9B3BB2Enzw094Z1pM=";
  };

  cargoHash = "sha256-+3ihh663k6Ay16fxCbO7CW343zxwUHusqBQpH8CDEoc=";

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
