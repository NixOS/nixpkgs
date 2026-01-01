{
  lib,
  pkgs,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  callPackage,
}:

buildPythonPackage rec {
  pname = "uv-build";
<<<<<<< HEAD
  version = "0.9.9";
=======
  version = "0.9.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-i9vdpHA9EfXmw5fhK1tTZG0T2zOlDbjPCGBIizvQzZw=";
=======
    hash = "sha256-I0Oe6vaH7iQh+Ubp5RIk8Ol6Ni7OPu8HKX0fqLdewyk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-RZkIjHQElqrj+UAz+q6w1CYW3E5/YW9uy2E5KpKvw+w=";
=======
    hash = "sha256-K/RP7EA0VAAI8TGx+VwfKPmyT6+x4p3kekuoMZ0/egc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildAndTestSubdir = "crates/uv-build";

  # $src/.github/workflows/build-binaries.yml#L139
<<<<<<< HEAD
  maturinBuildProfile = "minimal-size";
=======
  maturinBuildFlags = [ "--profile=minimal-size" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "uv_build" ];

  # The package has no tests
  doCheck = false;

  # Run the tests of a package built by `uv_build`.
  passthru = {
    tests.built-by-uv = callPackage ./built-by-uv.nix { inherit (pkgs) uv; };

    # updateScript is not needed here, as updating is done on staging
  };

  meta = {
    description = "Minimal build backend for uv";
    homepage = "https://docs.astral.sh/uv/reference/settings/#build-backend";
    inherit (pkgs.uv.meta) changelog license;
    maintainers = with lib.maintainers; [ bengsparks ];
  };
}
