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
  version = "nightly-2021-01-12";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = pname;
    rev = version;
    sha256 = "1lywxn61w0b3pb8vjpavd9f3v58gq35ypwp41b7rjkc4rjxmf3cd";
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
    wrapProgram $out/bin/ruffle_desktop --prefix LD_LIBRARY_PATH ':' ${vulkan-loader}/lib
  '';

  cargoSha256 = "113gh8nf2fs9shfvnzpwlc7zaq1l9l9jhlybcc4dq0wr4r8qpff5";

  meta = with lib; {
    description = "An Adobe Flash Player emulator written in the Rust programming language.";
    homepage = "https://ruffle.rs/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ govanify ];
    platforms = platforms.linux;
  };
}
