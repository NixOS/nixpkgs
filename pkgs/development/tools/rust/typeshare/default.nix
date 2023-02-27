{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "typeshare";
  version = "1.0.1";

  src = fetchCrate {
    inherit version;
    pname = "typeshare-cli";
    sha256 = "sha256-SbTI7170Oc1e09dv4TvUwByG3qkyAL5YXZ96NzI0FSI=";
  };

  cargoSha256 = "sha256-5EhXw2WcRJqCbdMvOtich9EYQqi0uwCH1a1XXIo8aAo=";

  buildFeatures = [ "go" ];

  meta = with lib; {
    description = "Command Line Tool for generating language files with typeshare";
    homepage = "https://github.com/1password/typeshare";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
