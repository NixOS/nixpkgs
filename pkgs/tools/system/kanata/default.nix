{ stdenv
, lib
, darwin
, rustPlatform
, fetchFromGitHub
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ci/0Ksmi0uNHIvpZlihWvGeNabzmk+k3fUeuMDVpFeE=";
  };

  cargoHash = "sha256-IzgVF6SHJjOB48VehQ5taD5iWQXFKLcVBWTEl3ArkGQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  buildFeatures = lib.optional withCmd "cmd";

  # Workaround for https://github.com/nixos/nixpkgs/issues/166205
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

  postInstall = ''
    install -Dm 444 assets/kanata-icon.svg $out/share/icons/hicolor/scalable/apps/kanata.svg
  '';

  meta = with lib; {
    description = "A tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ bmanuel linj ];
    platforms = platforms.unix;
    mainProgram = "kanata";
  };
}
