{ lib, stdenv, fetchFromGitHub, scons, qt4, alsa-lib }:

stdenv.mkDerivation {
  pname = "gambatte";
  version = "2020-03-14";

  src = fetchFromGitHub {
    owner = "sinamas";
    repo = "gambatte";
    rev = "56e3371151b5ee86dcdcf4868324ebc6de220bc9";
    sha256 = "0cc6zcvxpvi5hgcssb1zy0fkj9nk7n0d2xm88a4v05kpm5zw7sh2";
  };

  buildInputs = [ scons qt4 alsa-lib ];

  patches = [ ./fix-scons-paths.patch ];

  buildPhase = ''
    ./build_qt.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp gambatte_qt/bin/gambatte_qt $out/bin/
  '';

  meta = with lib; {
    description = "Portable, open-source Game Boy Color emulator";
    homepage = "https://github.com/sinamas/gambatte";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
