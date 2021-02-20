{ lib, cmake, fetchFromGitHub, libGL, libiconv, libX11, openal, stdenv }:

stdenv.mkDerivation rec {
  pname = "cen64";
  version = "unstable-2020-02-20";

  src = fetchFromGitHub {
    owner = "n64dev";
    repo = "cen64";
    rev = "6f9f5784bf0a720522c4ecb0915e20229c126aed";
    sha256 = "08q0a3b2ilb95zlz4cw681gwz45n2wrb2gp2z414cf0bhn90vz0s";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libGL libiconv openal libX11 ];

  installPhase = ''
    mkdir -p $out/bin
    mv cen64 $out/bin
  '';

  meta = with lib; {
    description = "A Cycle-Accurate Nintendo 64 Emulator";
    license = licenses.bsd3;
    homepage = "https://github.com/n64dev/cen64";
    maintainers = [ maintainers._414owen ];
    platforms = [ "x86_64-linux" ];
  };
}
