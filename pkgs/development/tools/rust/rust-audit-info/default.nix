{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-audit-info";
  version = "0.5.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-g7ElNehBAVSRRlqsxkNm20C0KOMkf310bXNs3EN+/NQ=";
  };

  cargoSha256 = "sha256-bKrdgz6dyv/PF5JXMq7uvsh7SsK/qEd2W7tm6+YYlxg=";

  meta = with lib; {
    description = "A command-line tool to extract the dependency trees embedded in binaries by cargo-auditable";
    mainProgram = "rust-audit-info";
    homepage = "https://github.com/rust-secure-code/cargo-auditable/tree/master/rust-audit-info";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
