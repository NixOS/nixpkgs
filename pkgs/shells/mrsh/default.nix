{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, readline }:

stdenv.mkDerivation rec {
  pname   = "mrsh";
  version = "2020-11-04";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mrsh";
    rev = "1738e41b2a35e5f99b9a1300a5f687478458226a";
    sha256 = "08gak5261d4sd6b2w2kscmdwa4gwcp5drgfyb3swyrj9cl0nlcbn";
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
