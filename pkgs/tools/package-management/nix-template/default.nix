{ lib, stdenv, rustPlatform, fetchFromGitHub
, makeWrapper
, nix
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-template";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jonringer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A1b/fgSr27sfMDnTi4R3PUZfhAdLA5wUOd4yh9/4Bnk=";
  };

  cargoSha256 = "sha256-resyY/moqLo4KWOKUvFJiOWealCmcEsLFgkN12slKN0=";

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  # needed for nix-prefetch-url
  postInstall = ''
    wrapProgram $out/bin/nix-template \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  meta = with lib; {
    description = "Make creating nix expressions easy";
    homepage = "https://github.com/jonringer/nix-template/";
    changelog = "https://github.com/jonringer/nix-template/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ jonringer ];
  };
}
