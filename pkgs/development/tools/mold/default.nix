{ lib
, stdenv
, fetchFromGitHub
, cmake
, mimalloc
, ninja
, openssl
, zlib
, testers
, mold
}:

stdenv.mkDerivation rec {
  pname = "mold";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "rui314";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IXXyZZw1Tp/s9YkPR5Y+A6LpvaRo+XfA8UJBtt5Bjmg=";
  };

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = [ openssl zlib ]
    ++ lib.optionals (!stdenv.isDarwin) [ mimalloc ];

  postPatch = ''
    sed -i CMakeLists.txt -e '/.*set(DEST\ .*/d'
  '';

  cmakeFlags = [ "-DMOLD_USE_SYSTEM_MIMALLOC:BOOL=ON" ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isDarwin [ "-faligned-allocation" ];

  passthru.tests.version = testers.testVersion { package = mold; };

  meta = with lib; {
    description = "A faster drop-in replacement for existing Unix linkers";
    longDescription = ''
      mold is a faster drop-in replacement for existing Unix linkers. It is
      several times faster than the LLVM lld linker. mold is designed to
      increase developer productivity by reducing build time, especially in
      rapid debug-edit-rebuild cycles.
    '';
    homepage = "https://github.com/rui314/mold";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ azahi nitsky ];
    platforms = platforms.unix;
  };
}
