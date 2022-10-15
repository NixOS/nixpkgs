{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lemmeknow";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-xDHgIo6VGBp27JMqhG4r/MZTIAA8ViAJqWJNchZywTs=";
  };

  cargoSha256 = "sha256-bPI8S2hNQnIPj8Sl0QYs6piCdWSUYFH1qcf7DL+oxIo=";

  meta = with lib; {
    description = "A tool to identify anything";
    homepage = "https://github.com/swanandx/lemmeknow";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
