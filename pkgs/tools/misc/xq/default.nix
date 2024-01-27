{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "xq";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-mgvs3/gseLnFtAciW5txtYqo+8DyyQC7y/tN1kDqcb4=";
  };

  cargoHash = "sha256-lSyJqGWlk3ldgAkyebuyUDLp8mJdwnw8ee6ZHQXU2Y4=";

  meta = with lib; {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "xq";
  };
}
