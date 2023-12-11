{ lib
, stdenv
, fetchFromGitHub
, cargo
, cmake
, rustPlatform
, rustc
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "corrosion";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "corrosion-rs";
    repo = "corrosion";
    rev = "v${version}";
    hash = "sha256-eE3RNLK5xKOjXeA+vDQmM1hvw92TbmPEDLdeqimgwcA=";
  };

  cargoRoot = "generator";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-j9tsRho/gWCGwXUYZSbs3rudT6nYHh0FSfBCAemZHmw=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  nativeBuildInputs = [
    cmake
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  meta = with lib; {
    description = "Tool for integrating Rust into an existing CMake project";
    homepage = "https://github.com/corrosion-rs/corrosion";
    changelog = "https://github.com/corrosion-rs/corrosion/blob/${src.rev}/RELEASES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
