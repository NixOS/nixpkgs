{ fetchFromGitLab, lib, rustPlatform, }:

rustPlatform.buildRustPackage {
  pname = "ograc";
  version = "0.1.6";
  src = fetchFromGitLab {
    owner = "lirnril";
    repo = "ograc";
    rev = "d09b3102ff7a364bf2593589327a16a473bd4f25";
    sha256 = "sha256-vdHPFY6zZ/OBNlJO3N/6YXcvlddw2wYHgFWI0yfSgVo=";
  };
  cargoSha256 = "sha256-HAeEd7HY+hbTUOkIt6aTfvPYLRPtdAcUGvkuBUMjohA=";

  meta = with lib; {
    description = "like cargo, but backwards";
    mainProgram = "ograc";
    homepage = "https://crates.io/crates/ograc";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sciencentistguy ];
  };
}

