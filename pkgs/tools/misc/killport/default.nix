{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "killport";
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-aGnjLgDn86OUFQGj7K7+DUSGJuNEIL52yXJz/Mt5DT0=";
  };

  cargoHash = "sha256-Z3+hqssm5g7rl3XCnrmjuPhsG8E0Yc2Qg8/mjGlnaT4=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  meta = with lib; {
    description = "A command-line tool to easily kill processes running on a specified port";
    homepage = "https://github.com/jkfran/killport";
    license = licenses.mit;
    maintainers = with maintainers; [ sno2wman ];
  };
}
