{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IRIyxQk0BqFufZafq7klUHAW1lculqbcH67kf3jtjwo=";
  };

  cargoHash = "sha256-yKQRjY+aEXU5C3LhAyavtX8PazbAvAHQ7fykmK7LAQ8=";

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
  };
}
