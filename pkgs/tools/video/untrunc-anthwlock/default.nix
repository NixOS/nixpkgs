{ lib, stdenv, fetchFromGitHub, ffmpeg, libui }:

stdenv.mkDerivation {
  pname = "untrunc-anthwlock";
  version = "2020.07.18";

  src = fetchFromGitHub {
    owner = "anthwlock";
    repo = "untrunc";
    rev = "a0bf2e8642ecdb7af5897ed9b0dd30a7d03520ae";
    sha256 = "14i2lq68q990hnm2kkfamlsi67bcml85zl8yjsyxc5h8ncc2f3dp";
  };

  buildInputs = [ ffmpeg libui ];

  buildPhase = ''
    runHook preBuild
    make IS_RELEASE=1 untrunc
    make IS_RELEASE=1 untrunc-gui
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D -t $out/bin untrunc untrunc-gui
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Restore a truncated mp4/mov (improved version of ponchio/untrunc)";
    homepage = "https://github.com/anthwlock/untrunc";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
