{ lib
, rustPlatform
, fetchCrate
, installShellFiles
, makeWrapper
, pkg-config
, ronn
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "httplz";
  version = "1.12.6";

  src = fetchCrate {
    inherit version;
    pname = "https";
    sha256 = "sha256-qkhou4Rmv31zwyL8aM7U0YUZwOb3KQMHdOQsOrRI1TA=";
  };

  cargoSha256 = "sha256-BuNCKtK9ePV0d9o/DlW098Y4DWTIl0YKyryXMv09Woc=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
    ronn
  ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
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
