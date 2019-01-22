{ stdenv, pkgs, slop, ffmpeg, fetchFromGitHub, makeWrapper}:

stdenv.mkDerivation rec {
  name = "capture-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "buhman";
    repo = "capture";
    rev  = "4be986f17462b8d520559429c74da6bf3a436259";
    sha256 = "172y06vs993x5v78zwl81xma1gkvjq1ad9rvmf3a217fyxsz4nhh";
  };

  buildInputs = [ makeWrapper ];

  patches = [ ./0001-eval-fix.patch ./0002-sane-defaults.patch ];

  installPhase = ''
    install -Dm755 src/capture.sh $out/bin/capture

    patchShebangs $out/bin/capture
    wrapProgram $out/bin/capture \
      --prefix PATH : '${stdenv.lib.makeBinPath [ slop ffmpeg ]}'
  '';

  meta = with stdenv.lib; {
    description = "A no bullshit screen capture tool";
    homepage = "https://github.com/buhman/capture";
    maintainers = [ maintainers.ar1a ];
  };
}
