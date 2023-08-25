{ lib
, stdenv
, rustPlatform
, fetchCrate
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "gen-license";
  version = "0.1.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-YZcycLQ436cjr2YTT7TEyMdeLTOl9oEfa5x3lgnnYyo=";
  };

  cargoHash = "sha256-2PT20eoXxBPhGsmHlEEGE2ZDyhyrD7tFdwnn3khjKNo=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Create licenses for your projects right from your terminal";
    homepage = "https://github.com/nexxeln/license-generator";
    license = licenses.mit;
    maintainers = [ maintainers.ryanccn ];
  };
}
