{ stdenv, fetchFromGitHub, coreutils }:

stdenv.mkDerivation rec {
  pname = "brightnessctl";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "Hummer12007";
    repo = "brightnessctl";
    rev = "${version}";
    sha256 = "1n1gb8ldgqv3vs565yhk1w4jfvrviczp94r8wqlkv5q6ab43c8w9";
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
