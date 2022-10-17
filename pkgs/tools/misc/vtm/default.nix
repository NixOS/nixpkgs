{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "vtm";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "netxs-group";
    repo = "vtm";
    rev = "v${version}";
    sha256 = "sha256-m22Bj/Zj72OMZgmmX4cIuhb0JO/K9FopvXi9V9cMqDg=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "../src" ];

  meta = {
    homepage = "https://vtm.netxs.online/";
    description = "Terminal multiplexer with window manager and session sharing";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ahuzik ];
  };
}
