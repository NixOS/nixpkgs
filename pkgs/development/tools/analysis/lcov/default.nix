 {lib, stdenv, fetchFromGitHub, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "lcov";
  version = "1.16";

  src = fetchFromGitHub {
    owner = "linux-test-project";
    repo = "lcov";
    rev = "v${version}";
    sha256 = "sha256-X1T5OqR6NgTNGedH1on3+XZ7369007By6tRJK8xtmbk=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];

  preBuild = ''
    patchShebangs bin/
    makeFlagsArray=(PREFIX=$out LCOV_PERL_PATH=$(command -v perl))
  '';

  postInstall = ''
    wrapProgram $out/bin/lcov --set PERL5LIB ${perlPackages.makeFullPerlPath [ perlPackages.PerlIOgzip perlPackages.JSON ]}
    wrapProgram $out/bin/genpng --set PERL5LIB ${perlPackages.makeFullPerlPath [ perlPackages.GD ]}
  '';

  meta = with lib; {
    description = "Code coverage tool that enhances GNU gcov";

    longDescription =
      '' LCOV is an extension of GCOV, a GNU tool which provides information
         about what parts of a program are actually executed (i.e.,
         "covered") while running a particular test case.  The extension
         consists of a set of PERL scripts which build on the textual GCOV
         output to implement the following enhanced functionality such as
         HTML output.
      '';

    homepage = "http://ltp.sourceforge.net/coverage/lcov.php";
    license = lib.licenses.gpl2Plus;

    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.all;
  };
}
