{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "textual-speedups";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "willmcgugan";
    repo = "textual-speedups";
    rev = "v${version}";
    hash = "sha256-zsDA8qPpeiOlmL18p4pItEgXQjgrQEBVRJazrGJT9Bw=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Bz4ocEziOlOX4z5F9EDry99YofeGyxL/6OTIf/WEgK4=";
  };

  meta = with lib; {
    description = "Implements some of Textual's classes in Rust, which should make Textual apps faster";
    homepage = "https://github.com/willmcgugan/textual-speedups";
    license = licenses.mit;
    maintainers = with maintainers; [ shikanime ];
  };
}
