{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "vtm";
  version = "0.9.9u";

  src = fetchFromGitHub {
    owner = "netxs-group";
    repo = "vtm";
    rev = "v${version}";
    sha256 = "sha256-ySelsabe5J3Wne8L/F01R/CMPibUR18ZKWH2s25t+KY=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "../src" ];

  meta = with lib; {
    description = "Terminal multiplexer with window manager and session sharing";
    homepage = "https://vtm.netxs.online/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ahuzik ];
  };
}
