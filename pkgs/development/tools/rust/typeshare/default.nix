{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "typeshare";
  version = "1.0.0";

  src = fetchCrate {
    inherit version;
    pname = "typeshare-cli";
    sha256 = "sha256-KDmE5f9B2lNVbjdF8d81NTJIwpvPhsoLMA8w7iYIIl8=";
  };

  cargoSha256 = "sha256-b983tSue9WHkPrcIhp5QSjwj+lESURUYueebjXUWMJY=";

  buildFeatures = [ "go" ];

  postInstall = ''
    ln -s $out/bin/typeshare{-cli,}
  '';

  meta = with lib; {
    description = "Command Line Tool for generating language files with typeshare";
    homepage = "https://github.com/1password/typeshare";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
