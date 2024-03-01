{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-M1log9JAgKB+S1jyieXNOhI8Wa0GwujbzyLJUd6b8VI=";
  };

  cargoHash = "sha256-KyiwupObxEVyDzwsQOKWw0+avhf96L83m7tiI6EK3/U=";

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
