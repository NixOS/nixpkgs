{ lib
, stdenv
, fetchFromGitHub
, libpcap
, yascreen
}:

stdenv.mkDerivation rec {
  pname = "bpfmon";
  version = "2.51";

  src = fetchFromGitHub {
    owner = "bbonev";
    repo = "bpfmon";
    rev = "refs/tags/v${version}";
    hash = "sha256-EGRxWq94BWceYXunzcOpMQv4g7cMjVCEWMR0ULGN2Jg=";
  };

  buildInputs = [
    libpcap
    yascreen
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "BPF based visual packet rate monitor";
    homepage = "https://github.com/bbonev/bpfmon";
    changelog = "https://github.com/bbonev/bpfmon/releases/tag/v${version}";
    maintainers = with maintainers; [ arezvov ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
