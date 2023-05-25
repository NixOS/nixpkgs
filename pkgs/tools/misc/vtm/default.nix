{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "vtm";
  version = "0.9.9i";

  src = fetchFromGitHub {
    owner = "netxs-group";
    repo = "vtm";
    rev = "v${version}";
    sha256 = "sha256-pkso0Bpb+0Zua3MIXXEbaJDl/oENa51157mXTJXJC/A=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "../src" ];

  meta = with lib; {
    description = "Terminal multiplexer with window manager and session sharing";
    homepage = "https://vtm.netxs.online/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ahuzik ];
  };
}
