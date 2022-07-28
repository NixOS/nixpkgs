{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "lethe";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "kostassoid";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uMpqN9xgA0S861JChfJebU6azxJN8ScftmX8yJV8NM8=";
  };

  cargoSha256 = "sha256-GeZ/25ZaD/vyQo02SUt1JtNUL2QCg0varOJC1M3Ji9s=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Tool to wipe drives in a secure way";
    homepage = "https://github.com/kostassoid/lethe";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
