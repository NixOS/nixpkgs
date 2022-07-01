{ lib
, stdenv
, clang
, fetchFromGitHub
, installShellFiles
, openssl
, libpcap
}:

stdenv.mkDerivation rec {
  pname = "cowpatty";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "joswr1ght";
    repo = pname;
    rev = version;
    sha256 = "0fvwwghhd7wsx0lw2dj9rdsjnirawnq3c6silzvhi0yfnzn5fs0s";
  };

  nativeBuildInputs = [
    clang
    installShellFiles
  ];

  buildInputs = [
    openssl
    libpcap
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "BINDIR=/bin"
  ];

  postInstall = ''
    installManPage cowpatty.1
    installManPage genpmk.1
  '';

  meta = with lib; {
    description = "Offline dictionary attack against WPA/WPA2 networks";
    homepage = "https://github.com/joswr1ght/cowpatty";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nico202 fab ];
    platforms = platforms.linux;
  };
}
