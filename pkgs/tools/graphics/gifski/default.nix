{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-Hlowm+wtj3bJBGJd/JndOaGC6iSdab3sURUjzshqh+k=";
  };

  cargoSha256 = "sha256-Ir3u57nCBgzEuwaOzx8z71cxXmrIJLkURhuwFRoB2Xw=";

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
