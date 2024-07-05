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
  version = "1.73";

  src = fetchFromGitHub {
    owner = "error27";
    repo = "smatch";
    rev = version;
    sha256 = "sha256-Pv3bd2cjnQKnhH7TrkYWfDEeaq6u/q/iK1ZErzn6bME=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite openssl ]
    ++ lib.optionals buildllvmsparse [ libllvm ]
    ++ lib.optionals buildc2xml [ libxml2.dev ];

  makeFlags = [ "PREFIX=${placeholder "out"}" "CXX=${stdenv.cc.targetPrefix}c++" ];

  meta = with lib; {
    description = "Semantic analysis tool for C";
    homepage = "https://sparse.docs.kernel.org/";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
