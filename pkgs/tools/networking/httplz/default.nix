{ lib
, rustPlatform
, fetchCrate
, fetchpatch
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
  version = "1.12.5";

  src = fetchCrate {
    inherit version;
    pname = "https";
    sha256 = "sha256-+nCqMTLrBYNQvoKo1PzkyzRCkKdlE88+NYoJcIlAJts=";
  };

  patches = [
    # https://github.com/thecoshman/http/pull/151
    (fetchpatch {
      name = "fix-rust-1.65-compile.patch";
      url = "https://github.com/thecoshman/http/commit/6e4c8e97cce09d0d18d4936f90aa643659d813fc.patch";
      hash = "sha256-mXclXfp2Nzq6Pr9VFmxiOzECGZEQRNOAcXoKhiOyuFs=";
    })
  ];

  cargoSha256 = "sha256-odiVIfNJPpagoASnYvdOosHXa37gbQM8Zmvtnao0pAs=";

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
