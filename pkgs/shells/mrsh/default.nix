{ stdenv, lib, fetchFromGitHub, meson, ninja, pkgconfig, readline }:

stdenv.mkDerivation rec {
  pname   = "mrsh";
  version = "2020-01-08";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mrsh";
    rev = "ef21854fc9ce172fb1f7f580b19a89d030d67c65";
    sha256 = "1iyxmwl61p2x9v9b22416n4lnrlwjqyxybq35x8bcbjxkwypp943";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ readline ];

  meta = with stdenv.lib; {
    description = "A minimal POSIX shell";
    homepage = "https://mrsh.sh";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux;
  };
}
