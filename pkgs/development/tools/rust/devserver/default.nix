{ lib
, fetchCrate
, rustPlatform
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "devserver";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-UcrLzsALwl0zqNRMS1kTTXsR6wN8XDd5Iq+yrudh6M4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoSha256 = "sha256-XlrQ6CvjeWnzvfaeNbe8FtMXMVSQNLxDVIEjyHm57Js=";

  meta = with lib; {
    description = "An extremely tiny tool to serve a static folder locally";
    homepage = "https://github.com/kettle11/devserver";
    license = licenses.zlib;
    maintainers = with maintainers; [ nickhu ];
  };
}
