{ stdenv, fetchFromGitHub, autoconf }:

stdenv.mkDerivation rec {
  name = "argbash";

  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "matejak";
    repo = "argbash";
    rev = "${version}";
    sha256 = "0jzfr2w5pza33mvw6hq6rm1vjgrfy95dp4421403jnji3ziwgf0w";
  };

  sourceRoot = "${src}/resources";

  nativeBuildInputs = [ autoconf ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Bash argument parsing code generator";
    homepage = "https://argbash.io/";
    license = licenses.free; # custom license.  See LICENSE in source repo.
    maintainers = with maintainers; [ rencire ];
  };
}
