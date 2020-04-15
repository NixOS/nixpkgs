{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowenv";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    sha256 = "1fjqm4qr85wb0i3vazp0w74izfzvkycdii7dlpdp5zs8jgb35pdh";
  };

  cargoSha256 = "1n8qh730nhdmpm08mm2ppcl3nkcgm50cyz9q5h6dlzq4bv4rijp4";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installManPage man/man1/shadowenv.1
    installManPage man/man5/shadowlisp.5
  '';

  meta = with stdenv.lib; {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "reversible directory-local environment variable manipulations";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
