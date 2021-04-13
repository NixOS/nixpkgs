{ lib, stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "gxlimg";
  version = "unstable-2020-10-30";

  src = fetchFromGitHub {
    owner = "repk";
    repo = pname;
    rev = "c545568fdd6a0470da4265a3532f5e652646707f";
    sha256 = "05799f3gdxjqcv0s7bba724n8pxr0hldcj0p5n9ab92vgasgnpcq";
  };

  buildInputs = [
    openssl
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    mv gxlimg "$out/bin"
  '';

  meta = with lib; {
    homepage = "https://github.com/repk/gxlimg";
    description = "Boot Image creation tool for amlogic s905x (GXL)";
    license = licenses.bsd2;
    maintainers = with maintainers; [ samueldr ];
  };
}
