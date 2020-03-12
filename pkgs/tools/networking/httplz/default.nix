{ stdenv, lib, fetchFromGitHub, makeWrapper, rustPlatform
, openssl, pkgconfig, darwin, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "httplz";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "thecoshman";
    repo = "http";
    rev = "v${version}";
    sha256 = "0i41hqig8v6w1qb6498239iix1rss0lznm5lcl9m3i439c2zv7pw";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    openssl pkgconfig
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "--bin httplz" ];
  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "13hk9m09jff3bxbixsjvksiir4j4mak4ckvlq45bx5d5lh8sapxl";

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
