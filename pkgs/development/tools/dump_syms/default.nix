{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl

# darwin
, Security
, SystemConfiguration

# tests
, firefox-esr-unwrapped
, firefox-unwrapped
, thunderbird-unwrapped
}:

let
  pname = "dump_syms";
  version = "2.3.4";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6VDuZ5rw2N4z6wOVbaOKO6TNaq8QA5RstsIzmuE3QrI=";
  };

  cargoHash = "sha256-ndRw5z4CfuX0KNqNgpA4yohG8p/cUR/Op2fIunuO6GM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    Security
    SystemConfiguration
  ];

  checkFlags = [
    # Disable tests that require network access
    # ConnectError("dns error", Custom { kind: Uncategorized, error: "failed to lookup address information: Temporary failure in name resolution" })) }', src/windows/pdb.rs:725:56
    "--skip windows::pdb::tests::test_ntdll"
    "--skip windows::pdb::tests::test_oleaut32"
  ];

  passthru.tests = {
    inherit firefox-esr-unwrapped firefox-unwrapped thunderbird-unwrapped;
  };

  meta = with lib; {
    changelog = "https://github.com/mozilla/dump_syms/blob/v${version}/CHANGELOG.md";
    description = "Command-line utility for parsing the debugging information the compiler provides in ELF or stand-alone PDB files";
    mainProgram = "dump_syms";
    license = licenses.asl20;
    homepage = "https://github.com/mozilla/dump_syms/";
    maintainers = with maintainers; [ hexa ];
  };
}
