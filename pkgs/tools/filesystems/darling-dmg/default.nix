{ stdenv, fetchFromGitHub, cmake, fuse, zlib, bzip2, openssl, libxml2, icu } :

stdenv.mkDerivation rec {
  pname = "darling-dmg";
  version = "1.0.4+git20200427";

  src = fetchFromGitHub {
    owner = "darlinghq";
    repo = "darling-dmg";
    rev = "71cc76c792db30328663272788c0b64aca27fdb0";
    sha256 = "08iphkxlmjddrxpbm13gxyqwcrd0k65z3l1944n4pccb6qbyj8gv";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ fuse openssl zlib bzip2 libxml2 icu ];


  meta = with stdenv.lib; {
    homepage = "https://www.darlinghq.org/";
    description = "Darling lets you open macOS dmgs on Linux";
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
