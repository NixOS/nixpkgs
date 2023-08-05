{ lib, stdenv, fetchFromGitHub, pkg-config, gengetopt, m4, gnupg
, git, perl, autoconf, automake, help2man, boehmgc }:

stdenv.mkDerivation rec {
  pname = "mmv";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "rrthomas";
    repo = "mmv";
    rev = "v${version}";
    sha256 = "sha256-tQk3AwmUuhbxvFm9wiO7BM2GChGopvpCZAp8J9XCDF0=";
    fetchSubmodules = true;
  };

  preConfigure = ''
    ./bootstrap
  '';

  nativeBuildInputs = [ gengetopt m4 git gnupg perl autoconf automake help2man pkg-config ];
  buildInputs = [ boehmgc ];

  meta = {
    homepage = "https://github.com/rrthomas/mmv";
    description = "Utility for wildcard renaming, copying, etc";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
