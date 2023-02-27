{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-JJSAU9z3JOlvfW6AW/P/KrjhOcD0ax8TmqgqM48rlAo=";
  };

  cargoHash = "sha256-UV2iQFbeGvJs8kEowYRNv8DxEGwaIWL1/3A2oUCcauw=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  # error: the crate `gifski` is compiled with the panic strategy `abort` which is incompatible with this crate's strategy of `unwind`
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
