{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, sqlite
, openssl
, buildllvmsparse ? false
, buildc2xml ? false
, libllvm
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "smatch";
  version = "1.72";

  src = fetchFromGitHub {
    owner = "error27";
    repo = "smatch";
    rev = version;
    sha256 = "sha256-XVW4sAgIxaJjAk75bp/O286uddIfgfKtIA2LniUGWBM=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite openssl ]
    ++ lib.optionals buildllvmsparse [ libllvm ]
    ++ lib.optionals buildc2xml [ libxml2.dev ];

  makeFlags = [ "PREFIX=${placeholder "out"}" "CXX=${stdenv.cc.targetPrefix}c++" ];

  meta = with lib; {
    description = "A semantic analysis tool for C";
    homepage = "http://smatch.sourceforge.net/";
    maintainers = with maintainers; [ marsam ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
