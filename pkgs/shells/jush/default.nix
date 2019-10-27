{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, editline }:

stdenv.mkDerivation rec {
  pname = "jush";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = pname;
    rev = "v${version}";
    sha256 = "1azvghrh31gawd798a254ml4id642qvbva64zzg30pjszh1087n8";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ editline ];

  passthru.shellPath = "/bin/jush";

  meta = with stdenv.lib; {
    description = "just a useless shell";
    homepage = https://github.com/troglobit/jush;
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
