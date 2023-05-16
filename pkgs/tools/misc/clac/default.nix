{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "clac";
<<<<<<< HEAD
  version = "0.3.3-unstable-2021-09-06";
=======
  version = "0.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "soveran";
    repo = "clac";
<<<<<<< HEAD
    rev = "beae8c4bc89912f4cd66bb875585fa471692cd54";
    sha256 = "XaULDkFF9OZW7Hbh60wbGgvCJ6L+3gZNGQ9uQv3G0zU=";
=======
    rev = version;
    sha256 = "rsag8MWl/udwXC0Gj864fAuQ6ts1gzrN2N/zelazqjE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p "$out/share/doc/${pname}"
    cp README* LICENSE "$out/share/doc/${pname}"
  '';

  meta = with lib; {
    description = "Interactive stack-based calculator";
    homepage = "https://github.com/soveran/clac";
    license = licenses.bsd2;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
