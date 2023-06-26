{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "clatd";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "toreanderson";
    repo = "clatd";
    rev = "v${version}";
    hash = "sha256-ZUGWQTXXgATy539NQxkZSvQA7HIWkIPsw1NJrz0xKEg=";
  };

  makeFlags = [
    "DESTDIR="
    "PREFIX=$(out)"
  ];

  preBuild = ''
    mkdir -p $out/sbin
  '';

  meta = with lib; {
    description = "A 464XLAT CLAT implementation for Linux";
    homepage = "https://github.com/toreanderson/clatd";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
