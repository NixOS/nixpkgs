{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "vtm";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "netxs-group";
    repo = "vtm";
    rev = "v${version}";
    sha256 = "sha256-TRuTvaCALQPxilkzSODdeI2P4FuxTGg8UTHkMDiuYTU=";
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
