{ lib
, stdenv
, fetchCrate
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bazel";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "FS1WFlK0YNq1QCi3S3f5tMN+Bdcfx2dxhDKRLXLcios=";
  };

  cargoSha256 = "+PVNB/apG5AR236Ikqt+JTz20zxc0HUi7z6BU6xq/Fw=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  # `test_data` is explicitly excluded from the package published to crates.io, so tests cannot be run
  doCheck = false;

  meta = with lib; {
    description = "Part of the `crate_universe` collection of tools which use Cargo to generate build targets for Bazel";
    homepage = "https://github.com/bazelbuild/rules_rust";
    license = licenses.asl20;
    maintainers = with maintainers; [ rickvanprim ];
  };
}
