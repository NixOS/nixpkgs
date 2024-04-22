{ lib, stdenv, fetchFromGitHub, zlib, libarchive, openssl }:

stdenv.mkDerivation rec {
  version = "1.0";
  pname = "makerpm";

  installPhase = ''
    mkdir -p $out/bin
    cp makerpm $out/bin
  '';

  buildInputs = [ zlib libarchive openssl ];

  src = fetchFromGitHub {
    owner = "ivan-tkatchev";
    repo = "makerpm";
    rev = version;
    sha256 = "089dkbh5705ppyi920rd0ksjc0143xmvnhm8qrx93rsgwc1ggi1y";
  };

  meta = with lib; {
    homepage = "https://github.com/ivan-tkatchev/makerpm/";
    description = "A clean, simple RPM packager reimplemented completely from scratch";
    mainProgram = "makerpm";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = [ maintainers.ivan-tkatchev ];
  };
}
