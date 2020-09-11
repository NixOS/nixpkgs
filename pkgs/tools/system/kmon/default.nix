{ stdenv, fetchFromGitHub, rustPlatform, python3, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f9q4bc1kr1hgwf8byj13d6vsfs97wz7x10zwa82iv9b0wb1lr5w";
  };

  cargoSha256 = "1xy8rkba9idd0w4bnczmv4ll9awvar99vb7s0jd25fjbzqqlz820";

  nativeBuildInputs = [ python3 ];

  buildInputs = [ libxcb ];

  postInstall = ''
    install -D man/kmon.8 -t $out/share/man/man8/
  '';

  meta = with stdenv.lib; {
    description = "Linux Kernel Manager and Activity Monitor";
    homepage = "https://github.com/orhun/kmon";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ misuzu ];
  };
}
