{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-iG7XaPBNTmt/yNMeSY8UKwesFJFUECAsOYQ0idegk1w=";
  };

  cargoHash = "sha256-7bjsxbUsHjsVER0HaQ+x0dkaAI2sb7if8mS6JwQIbzc=";

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
