{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ioping";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "koct9i";
    repo = "ioping";
    rev = "v${version}";
    sha256 = "0cv2496jplka55yqdcf3ln78r8yggy4lgmgf06l6fbljjrdx7pgq";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Disk I/O latency measuring tool";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    homepage = https://github.com/koct9i/ioping;
  };
}
