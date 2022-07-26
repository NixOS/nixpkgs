{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "snapraid";
  version = "12.1";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    rev = "v${version}";
    sha256 = "sha256-DaFL5YxKdL7swfiWAHNufkeQ7mNd/MdZ6E0yAtC58lc=";
  };

  VERSION = version;

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  meta = {
    homepage = "http://www.snapraid.it/";
    description = "A backup program for disk arrays";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.makefu ];
    platforms = lib.platforms.unix;
  };
}
