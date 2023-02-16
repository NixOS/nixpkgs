{ lib
, rustPlatform
, fetchCrate
, libxml2
, ncurses
, zlib
, features ? [ "default" ]
, llvmPackages_12
}:

rustPlatform.buildRustPackage rec {
  pname = "frawk";
  version = "0.4.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-fqOFFkw+mV9QLTH3K6Drk3kDqU4wrQTj7OQrtgYuD7M=";
  };

  cargoSha256 = "sha256-G39/CESjMouwPQJBdsmd+MBusGNQmyNjw3PJSFBCdSk=";

  buildInputs = [ libxml2 ncurses zlib ];

  buildNoDefaultFeatures = true;
  buildFeatures = features;

  preBuild = lib.optionalString (lib.elem "default" features || lib.elem "llvm_backend" features) ''
    export LLVM_SYS_120_PREFIX=${llvmPackages_12.llvm.dev}
  '' + lib.optionalString (lib.elem "default" features || lib.elem "unstable" features) ''
    export RUSTC_BOOTSTRAP=1
  '';

  # depends on cpu instructions that may not be available on builders
  doCheck = false;

  meta = with lib; {
    description = "A small programming language for writing short programs processing textual data";
    homepage = "https://github.com/ezrosent/frawk";
    changelog = "https://github.com/ezrosent/frawk/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
