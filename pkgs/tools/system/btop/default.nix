{ lib
, fetchFromGitHub
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Znap1MSWEdKtb9G7+DmfYAhq3q2NfGu1v2cjbYuvUmE=";
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
