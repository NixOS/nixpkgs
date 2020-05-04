{ stdenv, lib, fetchFromGitHub, makeWrapper, rustPlatform
, openssl, pkgconfig, darwin, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "httplz";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "thecoshman";
    repo = "http";
    rev = "v${version}";
    sha256 = "154alxxclz78r29m656c8yahnzq0vd64s4sp19h0ca92dfw4s46y";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    libiconv darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "--bin httplz" ];
  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "1rpwzrr9bvw375vn97y5fqhraqz35d3ani9kfflvn2758x3g8gwf";

  postInstall = ''
    wrapProgram $out/bin/httplz \
      --prefix PATH : "${openssl}/bin"
  '';

  meta = with stdenv.lib; {
    description = "A basic http server for hosting a folder fast and simply";
    homepage = "https://github.com/thecoshman/http";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
