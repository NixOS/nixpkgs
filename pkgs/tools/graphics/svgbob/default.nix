{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "0.6.4";

  src = fetchCrate {
    inherit version;
    crateName = "svgbob_cli";
    sha256 = "sha256-IPv6ZHgFJdH0hH9y1bQ+BHCS9EjX0Et2yuKwiYUW9gs=";
  };

  cargoSha256 = "sha256-mSeVrBQIoJ/uvxzLj15sreQHU2PAa3Xihdok89XpXeQ=";

  meta = with lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = "https://github.com/ivanceras/svgbob";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
