{ lib, stdenv, fetchFromGitHub, pam, bison, flex, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libcgroup";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-o9eXbsgtGhODEbpbEn30RbYfYpXo6xkU5ptU1och5tU=";
  };

  buildInputs = [ pam bison flex ];
  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    substituteInPlace src/tools/Makefile.am \
      --replace 'chmod u+s' 'chmod +x'
  '';

  meta = {
    description = "Library and tools to manage Linux cgroups";
    homepage    = "https://github.com/libcgroup/libcgroup";
    license     = lib.licenses.lgpl2;
    platforms   = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
