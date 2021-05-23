{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "ivanceras";
    repo = pname;
    rev = "0febc4377134a2ea3b3cd43ebdf5ea688a0e7432";
    sha256 = "1n0w5b3fjgbczy1iw52172x1p3y1bvw1qpz77fkaxkhrkgfd7vwr";
  };
  sourceRoot = "source/svgbob_cli";
  postPatch = ''
    substituteInPlace ../svgbob/src/lib.rs \
      --replace '#![deny(warnings)]' ""
  '';

  cargoSha256 = "1jyycr95gjginx6bzmay9b5dbpnbwdqbv13w1qy58znicsmh3v8a";

  # Test tries to build outdated examples
  doCheck = false;

  meta = with lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = "https://github.com/ivanceras/svgbob";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
