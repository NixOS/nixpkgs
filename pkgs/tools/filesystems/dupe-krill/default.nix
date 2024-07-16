{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dupe-krill";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ceeKG45OQLxiYcwq2Kumbpd+lkyY+W/og1/6Zdpd3zo=";
    postFetch = ''
      cp ${./Cargo.lock} $out/Cargo.lock
    '';
  };

  cargoHash = "sha256-jEMvvFOcFij4lT/5Y5xARaVURT/evV9u1Vkqtm4al+g=";

  meta = with lib; {
    description = "Fast file deduplicator";
    homepage = "https://github.com/kornelski/dupe-krill";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ urbas ];
    mainProgram = "dupe-krill";
  };
}
