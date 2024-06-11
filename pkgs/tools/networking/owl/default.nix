{ stdenv, lib, fetchFromGitHub, cmake, libev, libnl, libpcap }:

stdenv.mkDerivation rec {
  pname = "owl";
  version = "unstable-2022-01-30";

  src = fetchFromGitHub {
    owner = "seemoo-lab";
    repo = "owl";
    rev = "8e4e840b212ae5a09a8a99484be3ab18bad22fa7";
    sha256 = "sha256-kFk+JFLGWGBu5FPH3qp/Bxa6t04f1kpeHz3H8GNF3fg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libev libnl libpcap ];

  meta = with lib; {
    description = "Open Apple Wireless Direct Link (AWDL) implementation written in C";
    homepage = "https://owlink.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "owl";
  };
}
