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
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "convco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FGNMpBd2tgkJBbvgjgOYlLkAa8NqFUwa7rPp9jaWcio=";
  };

  cargoSha256 = "sha256-trlMO9+zf1+1cZu2jAzflB737ZT1lO/s1ekE5mGVo5Y=";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "A Conventional commit cli";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ hoverbear ];
  };
}
