{ stdenv, lib, fetchFromGitHub, makeWrapper, rustPlatform
, openssl, pkgconfig, darwin, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "httplz";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "thecoshman";
    repo = "http";
    rev = "v${version}";
    sha256 = "1y9mlbympb19i3iw7s7jm7lvkpcl4w0sig6jnd4w3ykhkdhzh6di";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    openssl pkgconfig
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "--bin httplz" ];
  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "1bxh7p2a04lpghqms8cx1f1cq5nbcx6cxh5ac7i72d5vzy4v07nl";

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
