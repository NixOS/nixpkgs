{ stdenv, fetchFromGitHub, lib, libpcap, yascreen }:

stdenv.mkDerivation rec {
  pname = "bpfmon";
  version = "2.50";

  src = fetchFromGitHub {
    owner = "bbonev";
    repo = "bpfmon";
    rev = "v${version}";
    sha256 = "sha256-x4EuGZBtg45bD9q1B/6KwjDRXXeRsdFmRllREsech+E=";
  };

  buildInputs = [ libpcap yascreen ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "BPF based visual packet rate monitor";
    homepage = "https://github.com/bbonev/bpfmon";
    maintainers = with maintainers; [ arezvov ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
