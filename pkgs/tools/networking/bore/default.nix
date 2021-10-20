{ lib, stdenv, rustPlatform, fetchFromBitbucket, llvmPackages, Libsystem, SystemConfiguration, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "bore";
  version = "0.3.3";

  src = fetchFromBitbucket {
    owner = "delan";
    repo = "nonymous";
    rev = version;
    sha256 = "0gws1f625izrb3armh6bay1k8l9p9csl37jx03yss1r720k4vn2x";
  };

  cargoSha256 = "1n09gcp1y885lz6g2f73zw3fd0fmv7nwlvaqba2yl0kylzk7naa6";
  cargoBuildFlags = "-p ${pname}";

  # FIXME can’t test --all-targets and --doc in a single invocation
  cargoTestFlags = "--features std --all-targets --workspace";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional stdenv.isDarwin llvmPackages.libclang;

  buildInputs = lib.optionals stdenv.isDarwin [
    Libsystem
    SystemConfiguration
  ];

  LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";

  postInstall = ''
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
    maintainers = [ maintainers.delan ];
  };
}
