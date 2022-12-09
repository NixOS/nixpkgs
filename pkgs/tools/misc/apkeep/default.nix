{ lib, stdenv, fetchCrate, rustPlatform, openssl, pkg-config, Security }:

rustPlatform.buildRustPackage rec {
  pname = "apkeep";
  version = "0.14.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ikI178fExFHYapg95NKtMxKT/4mXfVH+Jvaw8i1pSu4=";
  };

  cargoSha256 = "sha256-hA/GIj5MunflLlwa0S4o4EEr6Us+34dgYAAc43C6EXo=";

  prePatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A command-line tool for downloading APK files from various sources";
    homepage = "https://github.com/EFForg/apkeep";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
