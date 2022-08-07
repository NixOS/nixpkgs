{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-cycgrQ1f0x1tPziQCRyqWinG8v0SVYW3LpFsxhZpQhE=";
  };

  cargoPatches = [ ./cargo.lock-fix-missing-dependency.patch ];

  cargoSha256 = "sha256-qJ+awu+Ga3fdxaDKdSzCcdyyuKCheb87qT7tX1dL1zo=";

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
