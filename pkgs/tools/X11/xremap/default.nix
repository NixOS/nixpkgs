{ lib, fetchFromGitHub, rustPlatform, pkg-config, libX11 }:

rustPlatform.buildRustPackage rec {
  pname = "xremap";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0GlclKaXBnaWmLnby11ev+AuQSieIwE48b1mEs9+ovw=";
  };

  cargoSha256 = "sha256-Jz6GnM6TgYM3j7u9OySgJGEcj6ZV8A4Ku1woTLo4480=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libX11 ];

  buildFeatures = [ "x11" ];

  doCheck = false;

  meta = with lib; {
    description = "Dynamic key remapper for X11 and Wayland";
    homepage = "https://github.com/k0kubun/xremap";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ pbar1 ];
  };
}
