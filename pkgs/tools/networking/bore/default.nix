{ lib, stdenv, rustPlatform, fetchFromBitbucket, Libsystem, SystemConfiguration, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "bore";
  version = "0.4.1";

  src = fetchFromBitbucket {
    owner = "delan";
    repo = "nonymous";
    rev = "${pname}-${version}";
    hash = "sha256-qYFRUWSMy6xkBjHp+Y2hS+GWzsCGtbBnJvKh0E63trk=";
  };

  cargoSha256 = "1xlbfzmy0wjyz3jpr17r4ma4i79d9b32yqwwi10vrcjzr7vsyhmx";
  cargoBuildFlags = [ "-p" pname ];

  # error[E0793]: reference to packed field is unaligned
  doCheck = !stdenv.isDarwin;

  # FIXME can’t test --all-targets and --doc in a single invocation
  cargoTestFlags = [ "--all-targets" "--workspace" ];
  checkFeatures = [ "std" ];

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional stdenv.isDarwin rustPlatform.bindgenHook;

  buildInputs = lib.optionals stdenv.isDarwin [
    Libsystem
    SystemConfiguration
  ];

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
    maintainers = [ ];
    mainProgram = "bore";
    broken = stdenv.isDarwin; # bindgen fails on: "in6_addr_union_(...)" is not a valid Ident
  };
}
