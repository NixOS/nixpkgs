{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    sha256 = "sha256-/CH9cSOkgXxdxSN1G4Jg404KOHEYhnsSCK4QB6Zdk+A=";
  };

  cargoSha256 = "sha256-2knD3MwrJKvbdovh6bd81GqHHqeAG1OFzXsLB4eO0Do=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/gping --version | grep "${version}"
  '';

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
