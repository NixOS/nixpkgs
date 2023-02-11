{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "0.6.6";

  src = fetchCrate {
    inherit version;
    crateName = "svgbob_cli";
    sha256 = "sha256-NG5UbUv//03PVs5QoLVDkgA6Fc3SWKtbgIpcvcb7rW0=";
  };

  cargoSha256 = "sha256-CdPTtn0NTcEAQvLTh4vdG053oZNNMmbP5IxmMU4YGAw=";

  postInstall = ''
    mv $out/bin/svgbob_cli $out/bin/svgbob
  '';

  meta = with lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = "https://github.com/ivanceras/svgbob";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
