{ stdenv, fetchFromGitHub, cmake, pkgconfig, pcre }:

stdenv.mkDerivation {
  pname = "pplatex";
  version = "unstable-2015-09-14";

  src = fetchFromGitHub {
    owner = "stefanhepp";
    repo = "pplatex";
    rev = "5cec891ad6aec0115081cdd114ae1cc4f1ed7c06";
    sha256 = "0wrkkbz6b6x91650nm8gccz7xghlp7b1i31fxwalz9xw3py9xygb";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ pcre ];

  installPhase = ''
    runHook preInstall
    install -Dm555 src/pplatex "$out"/bin/pplatex
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description =
      "A tool to reformat the output of latex and friends into readable messages";
    homepage = "https://github.com/stefanhepp/pplatex";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.srgom ];
    platforms = platforms.unix;
  };
}
