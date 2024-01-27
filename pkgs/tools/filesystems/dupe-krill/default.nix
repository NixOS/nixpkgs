{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dupe-krill";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2fT9bw5LgJUQ0tm1T/vV5SaDjNH0OGKt7QUQLd7nmOs=";
    postFetch = ''
      cp ${./Cargo.lock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "sha256-JUcIDUVzSLzblb2EbmSfuCAB+S0fyW6wpGF0b/xR+b0=";

  meta = with lib; {
    description = "A fast file deduplicator";
    homepage = "https://github.com/kornelski/dupe-krill";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ urbas ];
    mainProgram = "dupe-krill";
  };
}
