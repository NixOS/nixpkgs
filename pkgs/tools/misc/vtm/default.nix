{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "vtm";
  version = "0.9.8q";

  src = fetchFromGitHub {
    owner = "netxs-group";
    repo = "vtm";
    rev = "v${version}";
    sha256 = "sha256-oY0zmyAgxMHPcBxFNdByQfeLIquw6eQ2SSfCgTKtO7Q=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "../src" ];

  meta = {
    homepage = "https://vtm.netxs.online/";
    description = "Terminal multiplexer with window manager and session sharing";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ahuzik ];
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
