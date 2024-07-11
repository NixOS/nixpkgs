{ lib, stdenv, fetchFromGitHub, pam, bison, flex, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libcgroup";
  version = "3.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-x2yBqpr3LedtWmpZ4K1ipZxIualNJuDtC4FVGzzcQn8=";
  };

  nativeBuildInputs = [ autoreconfHook bison flex ];
  buildInputs = [ pam ];

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
