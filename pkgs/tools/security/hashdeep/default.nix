{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "hashdeep";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "jessek";
    repo = "hashdeep";
    rev = "release-${version}";
    sha256 = "0m2b042ndikavmplv3qjdhfj44hl1h8car83c192xi9nv5ahi7mf";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "A set of cross-platform tools to compute hashes";
    homepage = "https://github.com/jessek/hashdeep";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ freebsd ++ openbsd;
    maintainers = [ maintainers.karantan ];
  };
}
