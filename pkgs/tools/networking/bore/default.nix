<<<<<<< HEAD
{ lib, stdenv, rustPlatform, fetchFromBitbucket, Libsystem, SystemConfiguration, installShellFiles }:
=======
{ lib, stdenv, rustPlatform, fetchFromBitbucket, llvmPackages, Libsystem, SystemConfiguration, installShellFiles }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

rustPlatform.buildRustPackage rec {
  pname = "bore";
  version = "0.4.1";

  src = fetchFromBitbucket {
    owner = "delan";
    repo = "nonymous";
    rev = "${pname}-${version}";
    sha256 = "1fdnnx7d18gj4rkv1dc6q379dqabl66zks9i0rjarjwcci8m30d9";
  };

  cargoSha256 = "1xlbfzmy0wjyz3jpr17r4ma4i79d9b32yqwwi10vrcjzr7vsyhmx";
  cargoBuildFlags = [ "-p" pname ];

<<<<<<< HEAD
  # error[E0793]: reference to packed field is unaligned
  doCheck = !stdenv.isDarwin;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # FIXME can’t test --all-targets and --doc in a single invocation
  cargoTestFlags = [ "--all-targets" "--workspace" ];
  checkFeatures = [ "std" ];

  nativeBuildInputs = [ installShellFiles ]
<<<<<<< HEAD
    ++ lib.optional stdenv.isDarwin rustPlatform.bindgenHook;
=======
    ++ lib.optional stdenv.isDarwin llvmPackages.libclang;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [
    Libsystem
    SystemConfiguration
  ];

<<<<<<< HEAD
=======
  LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
