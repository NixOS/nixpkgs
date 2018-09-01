{ stdenv, fetchFromGitHub, openssl, pkgconfig, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "cargo-web-${version}";
  version = "0.6.15";

  src = fetchFromGitHub {
    owner = "koute";
    repo = "cargo-web";
    rev = version;
    sha256 = "076g7cd9v53vi8xvd4kfsiyzw1m2hhd1lwlwcv2dx2s5vlw4dxzh";
  };

  cargoSha256 = "157av9zkirr00w9v11mh7yp8w36sy7rw6i80i5jmi0mgrdvcg5si";

  nativeBuildInputs = [ openssl pkgconfig ];

  meta = with stdenv.lib; {
    description = "A Cargo subcommand for the client-side Web";
    homepage = https://github.com/koute/cargo-web;
    license = with licenses; [asl20 /* or */ mit];
    maintainers = [ maintainers.kevincox ];
    platforms = platforms.all;
  };
}
