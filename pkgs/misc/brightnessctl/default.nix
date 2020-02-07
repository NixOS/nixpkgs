{ stdenv, fetchFromGitHub, coreutils }:

stdenv.mkDerivation rec {
  pname = "brightnessctl";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Hummer12007";
    repo = "brightnessctl";
    rev = version;
    sha256 = "0immxc7almmpg80n3bdn834p3nrrz7bspl2syhb04s3lawa5y2lq";
  };

  makeFlags = [ "PREFIX=" "DESTDIR=$(out)" ];

  postPatch = ''
    substituteInPlace 90-brightnessctl.rules --replace /bin/ ${coreutils}/bin/
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/Hummer12007/brightnessctl";
    description = "This program allows you read and control device brightness";
    license = licenses.mit;
    maintainers = with maintainers; [ megheaiulian ];
    platforms = platforms.linux;
  };

}
