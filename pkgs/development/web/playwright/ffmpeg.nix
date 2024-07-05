{ stdenv
, fetchzip
, suffix
, revision
, system
, throwSystem
}:
stdenv.mkDerivation {
  name = "ffmpeg";
  src = fetchzip {
    url = "https://playwright.azureedge.net/builds/ffmpeg/${revision}/ffmpeg-${suffix}.zip";
    stripRoot = false;
    sha256 = {
      x86_64-linux = "0k08xf43s0jvrnyrhb5bjilbg1kniab032c5bf2m60zjwflzpgz3";
      aarch64-linux = "10yzwhwblzg9sxl4328sfx0c06x7sp9xdi7i9mghz0qi7m43h4m2";
    }.${system} or throwSystem;
  };
  buildPhase = ''
    cp -R . $out
  '';
}
