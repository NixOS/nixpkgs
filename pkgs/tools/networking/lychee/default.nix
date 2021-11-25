{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "lychee";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TjjSysG4UCXVi5ytWaJVL31TFLHC3Ro5OEB56pzbn7s=";
  };

  cargoSha256 = "sha256-apRXxd7RBnNjhZb0xAUr5hSTafyMbg0k1wgHT93Z66g=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Disabled because they currently fail
  doCheck = false;

  meta = with lib; {
    description = "A fast, async, resource-friendly link checker written in Rust.";
    homepage = "https://github.com/lycheeverse/lychee";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ tuxinaut ];
    platforms = platforms.linux;
  };
}
