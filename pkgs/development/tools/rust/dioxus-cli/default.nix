{ lib, fetchCrate, rustPlatform, openssl, pkg-config, cacert, stdenv, CoreServices }:
rustPlatform.buildRustPackage rec {
  pname = "dioxus-cli";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-8S8zUOb2oiXbJQRgY/g9H2+EW+wWOQugr8+ou34CYPg=";
  };

  nativeBuildInputs = [ pkg-config cacert ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  cargoSha256 = "sha256-sCP8njwYA29XmYu2vfuog0NCL1tZlsZiupkDVImrYCE=";

  checkFlags = [
    # these tests require dioxous binary in PATH,
    # can be removed after: https://github.com/DioxusLabs/dioxus/pull/1138
    "--skip=cli::autoformat::spawn_properly"
    "--skip=cli::translate::generates_svgs"
  ];

  meta = with lib; {
    description = "CLI tool for developing, testing, and publishing Dioxus apps";
    homepage = "https://dioxuslabs.com";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xanderio ];
  };
}
