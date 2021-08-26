{ lib, stdenv, fetchFromGitHub, pam, bison, flex, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libcgroup";
  version = "0.42.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1h8s70lm6g7r0wj7j3xgj2g3j9fifvsy2pna6w0j3i5hh42qfms4";
  };

  buildInputs = [ pam bison flex ];
  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    substituteInPlace src/tools/Makefile.am \
      --replace 'chmod u+s' 'chmod +x'
  '';

  meta = {
    description = "Library and tools to manage Linux cgroups";
    homepage    = "http://libcg.sourceforge.net/";
    license     = lib.licenses.lgpl2;
    platforms   = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
