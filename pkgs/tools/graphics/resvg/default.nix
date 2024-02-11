{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B1rC0iU9KWB0k9iHjPL+rlU7KZ5s5cy+XqRpHENQvEc=";
  };

  cargoHash = "sha256-SCa10sejy4qeeo2slywl4qzscbQg5uyIeR1gE7mky2k=";

  cargoBuildFlags = [
    "--package=resvg"
    "--package=resvg-capi"
    "--package=usvg"
  ];

  postInstall = ''
    install -Dm644 -t $out/include crates/c-api/*.h
  '';

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    changelog = "https://github.com/RazrFalcon/resvg/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
    mainProgram = "resvg";
  };
}
