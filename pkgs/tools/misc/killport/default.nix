{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "killport";
  version = "0.9.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-aaKvrWJGZ26wyqoblAcUkGUPkbt8XNx9Z4xT+qI2B3o=";
  };

  cargoHash = "sha256-4CUMt5aDHq943uU5PAY1TJtmCqlBvgOruGQ69OG5fB4=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  meta = with lib; {
    description = "A command-line tool to easily kill processes running on a specified port";
    homepage = "https://github.com/jkfran/killport";
    license = licenses.mit;
    maintainers = with maintainers; [ sno2wman ];
    mainProgram = "killport";
  };
}
