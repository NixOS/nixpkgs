{ lib, stdenv, fetchFromGitHub, rustPlatform
, darwin, fontconfig, harfbuzz, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${version}";
    sha256 = "1p93428ln3sfsflc7spjpfcgy81c4z5y0xhwv5mkgzf55g8nrin1";
  };

  cargoSha256 = "0jzngl1iwrq20cx3l0mwdrrddvyw977rwb75nz1k4hkxjnicc1ga";

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
