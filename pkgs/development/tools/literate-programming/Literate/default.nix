{ lib, stdenv, fetchFromGitHub, ldc, dub }:

stdenv.mkDerivation {
  pname = "Literate";
  version = "unstable-2021-01-22";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "Literate";
    rev = "7004dffec0cff3068828514eca72172274fd3f7d";
    sha256 = "sha256-erNFe0+FlrslEENyO/YxYQbmec0voK31UWr5qVt+nXQ=";
    fetchSubmodules = true;
  };

  buildInputs = [ ldc dub ];

  HOME = "home";

  installPhase = "install -D bin/lit $out/bin/lit";

  meta = with lib; {
    description = "A literate programming tool for any language";
    homepage = "https://zyedidia.github.io/literate/";
    license = licenses.mit;
    mainProgram = "lit";
    platforms = platforms.unix;
  };
}
