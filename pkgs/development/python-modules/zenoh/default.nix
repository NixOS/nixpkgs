{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
}:

buildPythonPackage rec {
  pname = "zenoh";
<<<<<<< HEAD
  version = "1.6.2"; # nixpkgs-update: no auto update
=======
  version = "1.4.0"; # nixpkgs-update: no auto update
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-python";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-GGqZGtHSCaPeO6wFFBxPjdjhsIdcgI1RJ4mZbGq4uzc=";
=======
    hash = "sha256-X9AUjuJYA8j41JVS+ZLRYcQUzSRoGwmkNIH0UK5+QoU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname version;
<<<<<<< HEAD
    hash = "sha256-2Hieow0+GzcNQmvqsJd+5bpE9RWUDbaBR9jah+O4GtI=";
=======
    hash = "sha256-Z6Wtor/aAdO1JUUafFEo9RdI7OXmsAD5MMtMUF6CZEg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  pythonImportsCheck = [
    "zenoh"
  ];

  meta = {
    description = "Python API for zenoh";
    homepage = "https://github.com/eclipse-zenoh/zenoh-python";
    license = with lib.licenses; [
      asl20
      epl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
  };
}
