{ lib
, stdenv
, rustPackages_1_76
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
  version = "2.3.1";
in
rustPackages_1_76.rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mSup3AMYsPu/Az6QXhdCFSxGcIpel4zNN0g/95gPDS0=";
  };

  cargoSha256 = "sha256-INzCyF/tvCp4L6Btrw8AGTBAgdFiBlywzO3+SSE4beI=";

  # Workaround for https://github.com/nixos/nixpkgs/issues/166205
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals (stdenv.isDarwin) [
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
    changelog = "https://github.com/mozilla/dump_syms/releases/tag/v${version}";
    description = "Command-line utility for parsing the debugging information the compiler provides in ELF or stand-alone PDB files";
    license = licenses.asl20;
    homepage = "https://github.com/mozilla/dump_syms/";
    maintainers = with maintainers; [ hexa ];
  };
}
