{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, gdal, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "t-rex";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "t-rex-tileserver";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LUVk5li2cl/LKbhKOh6Bbwav0GEuI/vUbDPLn7NSRIs=";
  };

  cargoHash = "sha256-I4QmjTTKUp9iugEwzM0xCcNLvF5ozeBdYmbi8sytY88=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gdal openssl ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Vector tile server specialized on publishing MVT tiles";
    homepage = "https://t-rex.tileserver.ch/";
    changelog = "https://github.com/t-rex-tileserver/t-rex/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "t_rex";
    platforms = platforms.unix;
    broken = true;  # https://github.com/t-rex-tileserver/t-rex/issues/302
  };
}
