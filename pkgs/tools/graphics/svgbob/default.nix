{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "0.7.2";

  src = fetchCrate {
    inherit version;
    crateName = "svgbob_cli";
    sha256 = "sha256-QWDi6cpADm5zOzz8hXuqOBtVrqb0DteWmiDXC6PsLS4=";
  };

  cargoHash = "sha256-Fj1qjG4SKlchUWW4q0tBC+9fHFFuY6MHngJCFz6J5JY=";

  postInstall = ''
    mv $out/bin/svgbob_cli $out/bin/svgbob
  '';

  meta = with lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = "https://github.com/ivanceras/svgbob";
    changelog = "https://github.com/ivanceras/svgbob/raw/${version}/Changelog.md";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
