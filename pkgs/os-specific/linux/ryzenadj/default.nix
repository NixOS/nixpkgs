{ lib, stdenv, fetchFromGitHub, pciutils, cmake }:
stdenv.mkDerivation rec {
  pname = "ryzenadj";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "FlyGoat";
    repo = "RyzenAdj";
    rev = "v${version}";
    sha256 = "sha256-RoKRqqIVY9zjyXzGxHo+J4OV7cKc7CkqsdbpreB7EHc=";
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
