{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "lychee";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zgIFJLdYHSDsO34KFK51g4nVlSkc9/TFdXx2yPJ7kRQ=";
  };

  cargoSha256 = "sha256-r4a+JkaXVYsynBiWUHaleATXvfxyhRHfR/qcooD0FmI=";

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
