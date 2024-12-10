{
  asciidoctor,
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "tapview";
  version = "1.1";

  nativeBuildInputs = [ asciidoctor ];

  src = fetchFromGitLab {
    owner = "esr";
    repo = pname;
    rev = version;
    sha256 = "sha256-inrxICNglZU/tup+YnHaDiVss32K2OXht/7f8lOZI4g=";
  };

  # Remove unnecessary `echo` checks: `/bin/echo` fails, and `echo -n` works as expected.
  patches = [ ./dont_check_echo.patch ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "A minimalist pure consumer for TAP (Test Anything Protocol)";
    mainProgram = "tapview";
    homepage = "https://gitlab.com/esr/tapview";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
