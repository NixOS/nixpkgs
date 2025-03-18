{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, makeWrapper
, rr
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rr";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "danielzfranklin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-t8pRqeOdaRVG0titQhxezT2aDjljSs//MnRTTsJ73Yo=";
  };

  cargoHash = "sha256-P4r4XRolORdSGAsNg5RutZ2VVRR8rAfiBZNm+vIH3aM=";

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-rr --prefix PATH : ${lib.makeBinPath [ rr ]}
  '';

  meta = with lib; {
    description = "Cargo subcommand \"rr\": a light wrapper around rr, the time-travelling debugger";
    mainProgram = "cargo-rr";
    homepage = "https://github.com/danielzfranklin/cargo-rr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ otavio matthiasbeyer ];
  };
}
