{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, readline }:

stdenv.mkDerivation rec {
  pname   = "mrsh";
  version = "2020-07-27";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mrsh";
    rev = "0da902c0ee6f443fe703498e60f266af7f12537e";
    sha256 = "1yr09ln5p1s48aj8xv2d6dy0pahqvd86fkiwyc6zrjfq80igxf05";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ readline ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A minimal POSIX shell";
    homepage = "https://mrsh.sh";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
