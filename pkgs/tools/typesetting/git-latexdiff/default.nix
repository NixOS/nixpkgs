{ stdenv, fetchFromGitLab, git, bash }:

stdenv.mkDerivation rec {
  version = "1.1.2";
  name = "git-latexdiff-${version}";

  src = fetchFromGitLab {
    sha256 = "1alnrjcf3f1qv7fk8h9yachmdz7mjgcynlgsvchfgcb2cpdavxjg";
    rev = "v${version}";
    repo = "git-latexdiff";
    owner = "git-latexdiff";
  };

  buildInputs = [ git bash ];

  dontBuild = true;

  patches = [ ./shebang.patch ./version-test.patch ];

  postPatch = ''
    substituteInPlace git-latexdiff \
      --replace "@GIT_LATEXDIFF_VERSION@" "v${version}"
  '';

  installPhase = ''
    mkdir -p $prefix/bin
    mv git-latexdiff $prefix/bin
    chmod +x $prefix/bin/git-latexdiff
  '';

  meta = with stdenv.lib; {
    description = "View diff on LaTeX source files on the generated PDF files";
    maintainers = [ maintainers.DamienCassou ];
    license = licenses.free; # https://gitlab.com/git-latexdiff/git-latexdiff/issues/9
  };
}
