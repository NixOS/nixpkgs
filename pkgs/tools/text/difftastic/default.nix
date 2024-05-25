{ lib
, rustPlatform
, fetchFromGitHub
, testers
, difftastic
}:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.58.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    hash = "sha256-PTc8/NhWsLcKJj+9ebV/YaWEmyOWKJCYUjmVbr4z2SY=";
  };

  cargoSha256 = "sha256-wtWJ32bBoCmx+eGkrOk8o0OQFMhGYZEBEDI1oHn3Zuw=";

  # skip flaky tests
  checkFlags = [
    "--skip=options::tests::test_detect_display_width"
  ];

  passthru.tests.version = testers.testVersion { package = difftastic; };

  meta = with lib; {
    description = "A syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 figsoda ];
    mainProgram = "difft";
  };
}
