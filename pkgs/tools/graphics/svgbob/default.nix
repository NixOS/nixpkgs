{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "0.7.0";

  src = fetchCrate {
    inherit version;
    crateName = "svgbob_cli";
    sha256 = "sha256-iWcd+23/Ou7K2YUDf/MJx84LsVMXXqAkGNPs6B0RDqA=";
  };

  cargoHash = "sha256-YbbVv2ln01nJfCaopKCwvVN7cgrcuaRHNXGHf9j9XUY=";

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
