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
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "convco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-irn6L8tKOrtgTExLw5ycPLNZcnCKNEW6RayZVePVofw=";
  };

  cargoHash = "sha256-eoWtmUQf1/X4cd/b1aiNoN8HS+qrylaoTdq21/97kPU=";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "A Conventional commit cli";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ hoverbear ];
  };
}
