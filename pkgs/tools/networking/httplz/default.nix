{ lib
, rustPlatform
, fetchCrate
, installShellFiles
, makeWrapper
, pkg-config
, ronn
, openssl
, stdenv
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "httplz";
  version = "1.12.2";

  src = fetchCrate {
    inherit version;
    pname = "https";
    sha256 = "sha256-FhxNYss6n0AJEszpJ7+6CAJE2sdsflWQkvSLakTnFdY=";
  };

  cargoSha256 = "sha256-wyksA3RYpGkD6nhllNv8WkUwEdml4TiPM2a4GzfBD1o=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
    ronn
  ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  cargoBuildFlags = [ "--bin" "httplz" ];

  postInstall = ''
    sed -E 's/http(`| |\(|$)/httplz\1/g' http.md > httplz.1.ronn
    RUBYOPT=-Eutf-8:utf-8 ronn --organization "http developers" -r httplz.1.ronn
    installManPage httplz.1
    wrapProgram $out/bin/httplz \
      --prefix PATH : "${openssl}/bin"
  '';

  meta = with lib; {
    description = "A basic http server for hosting a folder fast and simply";
    homepage = "https://github.com/thecoshman/http";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
