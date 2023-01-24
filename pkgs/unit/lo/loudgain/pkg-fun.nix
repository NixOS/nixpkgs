{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, ffmpeg, libebur128
, libresample, taglib, zlib }:

stdenv.mkDerivation rec {
  pname = "loudgain";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "Moonbase59";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XLj+n0GlY/GAkJlW2JVMd0jxMzgdv/YeSTuF6QUIGwU=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ ffmpeg libebur128 libresample taglib zlib ];

  postInstall = ''
    sed -e "1aPATH=$out/bin:\$PATH" -i "$out/bin/rgbpm"
  '';

  meta = src.meta // {
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
