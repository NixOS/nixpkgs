{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "functiontrace-server";
  version = "0.5.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-p6ypMfg99ohQCyPB2O0wXbGmPvD2K9V3EnFDd5dC6js=";
  };

  cargoHash = "sha256-3tLjW7yiS1dNsV81KUZbfN2pvYT9kqiC62nWFid2NH8=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin
    [ darwin.apple_sdk.frameworks.CoreFoundation ];

  meta = with lib; {
    description = "Server for FunctionTrace, a graphical Python profiler";
    homepage = "https://functiontrace.com";
    license = with licenses; [ prosperity30 ];
    maintainers = with maintainers; [ tehmatt ];
  };
}
