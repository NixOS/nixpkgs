{ lib
, stdenv
, fetchFromGitHub
, libpcap
, yascreen
}:

stdenv.mkDerivation rec {
  pname = "bpfmon";
<<<<<<< HEAD
  version = "2.52";
=======
  version = "2.51";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bbonev";
    repo = "bpfmon";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-W7OnrC+FCxMd4YbYiybjIvO0LT7Hr1/0Y3BQwItaTBs=";
=======
    hash = "sha256-EGRxWq94BWceYXunzcOpMQv4g7cMjVCEWMR0ULGN2Jg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
