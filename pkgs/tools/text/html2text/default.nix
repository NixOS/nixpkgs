{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "html2text";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "grobian";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f1hpkxbg29rccx3lh2360lyry04f1zw5lq1nawhj3rrzlrkjgcl";
  };

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Convert HTML to plain text";
    homepage = "http://www.mbayer.de/html2text/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eikek ];
  };
}
