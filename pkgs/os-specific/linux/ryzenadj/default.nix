{ lib, stdenv, fetchFromGitHub, pciutils, cmake }:
stdenv.mkDerivation rec {
  pname = "ryzenadj";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "FlyGoat";
    repo = "RyzenAdj";
    rev = "v${version}";
    sha256 = "182l9nchlpl4yr568n86086glkr607rif92wnwc7v3aym62ch6ld";
  };

  nativeBuildInputs = [ pciutils cmake ];

  installPhase = ''
    install -D libryzenadj.so $out/lib/libryzenadj.so
    install -D ryzenadj $out/bin/ryzenadj
  '';

  meta = with lib; {
    description = "Adjust power management settings for Ryzen Mobile Processors.";
    homepage = "https://github.com/FlyGoat/RyzenAdj";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ asbachb ];
    platforms = [ "x86_64-linux" ];
  };
}
