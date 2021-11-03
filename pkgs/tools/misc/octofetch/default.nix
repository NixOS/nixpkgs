{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "octofetch";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "azur1s";
    repo = pname;
    rev = version;
    sha256 = "sha256-ciBFTVdHotjifNAoXJjI9CumyK98OkMmfWMbrEldlNI=";
  };

  cargoSha256 = "sha256-Gzemm5HY6YwlxesQlil6R+34OtAeU2k7f/9+Lll3i8k=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Github user information on terminal";
    homepage = "https://github.com/azur1s/octofetch";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
