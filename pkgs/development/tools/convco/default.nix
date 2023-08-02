{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, cmake
, libiconv
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "convco";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "convco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HOHUyO2Ct0BlQtLqqwsQZZPmnLij8AsayX+aIhIpZpw=";
  };

  cargoHash = "sha256-p8aDqBZ0HpQ4iWG0lAF6KIvE4F5P1myd/Dt/txaoz0k=";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "A Conventional commit cli";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ hoverbear ];
  };
}
