{ alsa-lib
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
  version = "nightly-2021-05-14";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = pname;
    rev = version;
    sha256 = "15azv8y7a4sgxvvhl7z45jyxj91b4nn681vband5726c7znskhwl";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    alsa-lib
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

  cargoSha256 = "0ihy4rgw9b4yqlqs87rx700h3a8wm02wpahhg7inic1lcag4bxif";

  meta = with lib; {
    description = "An Adobe Flash Player emulator written in the Rust programming language.";
    homepage = "https://ruffle.rs/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ govanify ];
    platforms = platforms.linux;
  };
}
