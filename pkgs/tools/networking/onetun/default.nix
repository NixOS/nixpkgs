{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "onetun";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "aramperes";
    repo = pname;
    rev = "v${version}";

    sha256 = "sha256-TYDSAJxWwNF/e42KR9656vrWfIanFMaJKvof0gcZ80U=";
  };

  cargoSha256 = "sha256-aki3jL+0ETPa/0eMyxuBKdF3K1wM86BZx8FrOkaUAFQ=";

  meta = with lib; {
    description = "A cross-platform, user-space WireGuard port-forwarder that requires no root-access or system network configurations";
    homepage = "https://github.com/aramperes/onetun";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
