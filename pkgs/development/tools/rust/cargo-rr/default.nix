{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, makeWrapper
, rr
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rr";
  version = "temp-disable-filters";

  src = fetchFromGitHub {
    owner = "danielzfranklin";
    repo = pname;
    rev = version;
    sha256 = "sha256-7ln7D6KUrUJV0lBPb2SdbvSXjZeJuru+ipyGeICk/p8=";
  };

  cargoSha256 = "sha256-RAkSCpWG/lr8zymlvQQwq/KWkY+uQXGqWdUn7ySJ8dA=";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-rr --prefix PATH : ${lib.makeBinPath [ rr ]}
  '';

  meta = with lib; {
    description = "Cargo subcommand \"rr\": a light wrapper around rr, the time-travelling debugger";
    homepage = "https://github.com/danielzfranklin/cargo-rr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
