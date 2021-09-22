{ lib
, fetchFromGitHub
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pa9i65ndx8LMTMRXyL2GXCauM6Q8gAb16zGOylQFwL0=";
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
