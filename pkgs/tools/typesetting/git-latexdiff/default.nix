{ lib, stdenv, fetchFromGitLab, git, bash }:

stdenv.mkDerivation rec {
  version = "1.6.0";
  pname = "git-latexdiff";

  src = fetchFromGitLab {
    hash = "sha256-DMoGEbCBuqUGjbna3yDpD4WNTikPudYRD4Wy1pPG2mw=";
    rev = version;
    repo = "git-latexdiff";
    owner = "git-latexdiff";
  };

  buildInputs = [ git bash ];

  dontBuild = true;

  patches = [ ./version-test.patch ];

  postPatch = ''
    substituteInPlace git-latexdiff \
      --replace "@GIT_LATEXDIFF_VERSION@" "v${version}"
    patchShebangs git-latexdiff
  '';

  installPhase = ''
    mkdir -p $prefix/bin
    mv git-latexdiff $prefix/bin
    chmod +x $prefix/bin/git-latexdiff
  '';

  meta = with lib; {
    description = "View diff on LaTeX source files on the generated PDF files";
    homepage = "https://gitlab.com/git-latexdiff/git-latexdiff";
    maintainers = [ ];
    license = licenses.bsd3; # https://gitlab.com/git-latexdiff/git-latexdiff/issues/9
    platforms = platforms.unix;
  };
}
