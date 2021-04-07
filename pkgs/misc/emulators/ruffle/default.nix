{ alsaLib
, fetchFromGitHub
, makeWrapper
, openssl
, pkg-config
, python3
, rustPlatform
, lib
, wayland
, xorg
, vulkan-loader
}:

rustPlatform.buildRustPackage rec {
  pname = "ruffle";
  version = "nightly-2021-04-02";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = pname;
    rev = version;
    sha256 = "1diz94y53hvii28894zz65aya12v8yw1864lqpkrdbj67yc6ykdj";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    alsaLib
    openssl
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libxcb
    xorg.libXrender
    vulkan-loader
  ];

  postInstall = ''
    # This name is too generic
    mv $out/bin/exporter $out/bin/ruffle_exporter

    wrapProgram $out/bin/ruffle_desktop --prefix LD_LIBRARY_PATH ':' ${vulkan-loader}/lib
  '';

  cargoSha256 = "0pnp5kmij4dwwvmgdv81mqcawcjcgg5gd6cpyf0xalyfjgj8i732";

  meta = with lib; {
    description = "An Adobe Flash Player emulator written in the Rust programming language.";
    homepage = "https://ruffle.rs/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ govanify ];
    platforms = platforms.linux;
  };
}
