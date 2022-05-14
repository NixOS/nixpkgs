{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

let
  pname = "dump_syms";
  version = "unstable-2022-05-05";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = "c2743d59b5aa321ade698f84b90f86b3d35a1b06";
    hash = "sha256-hWK9KrYqbfrF8b7i33InlTa/XkoZs+h49kUsKeSaAok=";
  };

  cargoSha256 = "sha256:0vsr867nl156wpxpw01bv9fxsp6rhj9vvpz2i2yhx4kjgr1qk1kw";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  checkFlags = [
    # Disable tests that require network access
    # ConnectError("dns error", Custom { kind: Uncategorized, error: "failed to lookup address information: Temporary failure in name resolution" })) }', src/windows/pdb.rs:725:56
    "--skip windows::pdb::tests::test_ntdll"
    "--skip windows::pdb::tests::test_oleaut32"
  ];

  meta = with lib; {
    changelog = "https://github.com/mozilla/dump_syms/releases/tag/v${version}";
    description = "Command-line utility for parsing the debugging information the compiler provides in ELF or stand-alone PDB files";
    license = licenses.asl20;
    homepage = "https://github.com/mozilla/dump_syms/";
    maintainers = with maintainers; [ hexa ];
  };
}
