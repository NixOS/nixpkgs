{ lib, fetchFromGitHub, rustPlatform, python3, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zbTS4nGb2jDYGhNYxoPaVv9kAc51CQOi9qiHiSLjAjo=";
  };

  cargoSha256 = "sha256-ujVlOShZOuaV3B1ydggVJXLNMQHoTZC0dJaw+/ajVFg=";

  nativeBuildInputs = [ python3 ];

  buildInputs = [ libxcb ];

  postInstall = ''
    install -D man/kmon.8 -t $out/share/man/man8/
  '';

  meta = with lib; {
    description = "Linux Kernel Manager and Activity Monitor";
    homepage = "https://github.com/orhun/kmon";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ misuzu ];
  };
}
