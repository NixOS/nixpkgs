{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl

# darwin
, Security

# tests
, firefox-esr-unwrapped
, firefox-unwrapped
, thunderbird-unwrapped
}:

let
  pname = "dump_syms";
  version = "2.2.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YzGFzmAGHev3gM6+l0sC+nCdyEYZI2G30U1JBrZ2uSU=";
  };

  cargoSha256 = "sha256-gWLd1MUpCeVRUgzqkA5USmlYDq8BmmB/EQfiFl9JsjA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals (stdenv.isDarwin) [
    Security
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
    changelog = "https://github.com/mozilla/dump_syms/releases/tag/v${version}";
    description = "Command-line utility for parsing the debugging information the compiler provides in ELF or stand-alone PDB files";
    license = licenses.asl20;
    homepage = "https://github.com/mozilla/dump_syms/";
    maintainers = with maintainers; [ hexa ];
  };
}
