{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "lethe";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "kostassoid";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0UYUzef7ja8nc2zs7eWqqXQfVVbEJEH9/NRRHVkvkYk=";
  };

  cargoSha256 = "sha256-suE8USKTZECVlTX4Wpz3vapo/Wmn7qaC3eyAJ3gmzqk=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Tool to wipe drives in a secure way";
    homepage = "https://github.com/kostassoid/lethe";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
