{ lib, stdenv, fetchFromGitHub, rustPlatform
, darwin, fontconfig, harfbuzz, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${version}";
    fetchSubmodules = true;
    sha256 = "1qncjapqw2x44lnvhp0z860d1py4mhvjqv6h1rhl9h1f7bsd7jq8";
  };

  cargoSha256 = "1drfgrsfz44yqz15bcmb3dyyz7dr9zbs3idl1ssaiir24d4z1m9z";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fontconfig harfbuzz openssl ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

  postInstall = lib.optionalString stdenv.isLinux ''
    install -D dist/appimage/tectonic.desktop -t $out/share/applications/
    install -D dist/appimage/tectonic.svg -t $out/share/icons/hicolor/scalable/apps/
  '';

  doCheck = true;

  meta = with lib; {
    description = "Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive";
    homepage = "https://tectonic-typesetting.github.io/";
    changelog = "https://github.com/tectonic-typesetting/tectonic/blob/tectonic@${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.lluchs maintainers.doronbehar ];
  };
}
