{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "pixi";
  version = "v0.1.0";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    rev = version;
    hash = "sha256-n1TZLgc3TTUs0F/DSKl3nPLkx8jmzlpp2dFII4u8hLQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-6uhb38Ofa2QOKn+rp3/gv4mPXrJuyWfiudwgwnJb85s=";

  doCheck = false;

  meta = with lib; {
    description = "Package management made easy";
    homepage = "https://github.com/prefix-dev/pixi";
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
