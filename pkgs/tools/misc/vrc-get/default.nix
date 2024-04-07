{ fetchCrate, lib, rustPlatform, pkg-config, stdenv, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "1.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-+xbHw1DpFmapjsFoUvxUqTok8TKMebMw3gYjO/rx/iU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  cargoHash = "sha256-iuLhDcii+wXDNUsUMo8lj4kfJve5RAz7FT5Pxs9yFPQ=";

  meta = with lib; {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/vrc-get/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "vrc-get";
  };
}
