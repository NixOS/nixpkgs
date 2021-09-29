{ lib
, fetchFromGitHub
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    sha256 = "14d41q9hfwmzhxqrnrz17rgbi03j0xga2jmw8n9y2v21rqxg73y0";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A monitor of resources";
    homepage = "https://github.com/aristocratos/btop";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
