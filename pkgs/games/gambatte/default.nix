{ stdenv, fetchFromGitHub, scons, qt4 }:

stdenv.mkDerivation rec {
  name = "gambatte-${version}";
  version = "2016-05-03";

  src = fetchFromGitHub {
    owner = "sinamas";
    repo = "gambatte";
    rev = "f8a810b103c4549f66035dd2be4279c8f0d95e77";
    sha256 = "1arv4zkh3fhrghsykl4blazc9diw09m44pyff1059z5b98smxy3v";
  };

  buildInputs = [ scons qt4 ];

  patches = [ ./fix-scons-paths.patch ];

  buildPhase = ''
    ./build_qt.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp gambatte_qt/bin/gambatte_qt $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Portable, open-source Game Boy Color emulator";
    homepage = https://github.com/sinamas/gambatte;
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
