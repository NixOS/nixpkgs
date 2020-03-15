{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ioping";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "koct9i";
    repo = "ioping";
    rev = "v${version}";
    sha256 = "10bv36bqga8sdifxzywzzpjil7vmy62psirz7jbvlsq1bw71aiid";
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
