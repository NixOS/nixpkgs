{ stdenv, slop, ffmpeg, fetchFromGitHub, makeWrapper}:

stdenv.mkDerivation rec {
  name = "capture-unstable-${version}";
  version = "2019-03-10";

  src = fetchFromGitHub {
    owner = "buhman";
    repo = "capture";
    rev  = "80dd9e7195aad5c132badef610f19509f3935b24";
    sha256 = "0zyyg4mvrny7cc2xgvfip97b6yc75ka5ni39rwls93971jbk83d6";
  };

  buildInputs = [ makeWrapper ];

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
    license = licenses.gpl3Plus;
  };
}
