{ lib, stdenv, fetchFromGitLab, autoreconfHook, libiconv }:

stdenv.mkDerivation rec {
  pname = "html2text";
  version = "2.2.3";

  src = fetchFromGitLab {
    owner = "grobian";
    repo = "html2text";
    rev = "v${version}";
    hash = "sha256-7Ch51nJ5BeRqs4PEIPnjCGk+Nm2ydgJQCtkcpihXun8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = {
    description = "Convert HTML to plain text";
    mainProgram = "html2text";
    homepage = "https://gitlab.com/grobian/html2text";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eikek ];
  };
}
