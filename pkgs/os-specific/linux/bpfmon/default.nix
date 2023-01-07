{ stdenv, fetchFromGitHub, lib, libpcap, yascreen }:

stdenv.mkDerivation rec {
  pname = "bpfmon";
  version = "2.51";

  src = fetchFromGitHub {
    owner = "bbonev";
    repo = "bpfmon";
    rev = "v${version}";
    sha256 = "sha256-EGRxWq94BWceYXunzcOpMQv4g7cMjVCEWMR0ULGN2Jg=";
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
