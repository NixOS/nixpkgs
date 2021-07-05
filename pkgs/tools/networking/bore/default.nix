{ lib, stdenv, rustPlatform, fetchFromBitbucket, llvmPackages, darwin, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "bore";
  version = "0.3.1";

  src = fetchFromBitbucket {
    owner = "delan";
    repo = "nonymous";
    rev = version;
    sha256 = "1xa94kqx5j24vb0nfwc4fzmr9pl6lcf2smbxwahv2yhjpl3yjlhz";
  };

  cargoSha256 = "0qsxvk77s14bxbhw8c9ixmn3glhw2w68wdz9vwcv722g04pfdwap";
  cargoBuildFlags = "-p ${pname}";

  # FIXME can’t test --all-targets and --doc in a single invocation
  cargoTestFlags = "--features std --all-targets --workspace";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional stdenv.isDarwin [
    llvmPackages.libclang
  ];

  buildInputs = lib.optional stdenv.isDarwin [
    darwin.Libsystem
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";

  preFixup = ''
    installManPage $src/bore/doc/bore.1
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    printf '\0\0\0\0\0\0\0\0\0\0\0\0' \
    | $out/bin/bore --decode \
    | grep -q ';; NoError #0 Query 0 0 0 0 flags'
  '';

  meta = with lib; {
    description = "DNS query tool";
    homepage = "https://crates.io/crates/bore";
    license = licenses.isc;
    maintainers = maintainers.delan;
    mainProgram = "bore";
  };
}
