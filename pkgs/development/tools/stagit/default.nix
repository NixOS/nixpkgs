{ lib, stdenv, libgit2, fetchgit }:

stdenv.mkDerivation rec {
  pname = "stagit";
  version = "1.0";

  src = fetchgit {
    url = "git://git.codemadness.org/stagit";
    rev = version;
    sha256 = "sha256-4QSKW89RyK/PpGE+lOHFiMTI82pdspfObnzd0rcgQkg=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ libgit2 ];

  meta = with lib; {
    description = "git static site generator";
    homepage = "https://git.codemadness.org/stagit/file/README.html";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jb55 sikmir ];
  };
}
