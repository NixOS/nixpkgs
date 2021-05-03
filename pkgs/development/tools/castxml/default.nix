{ lib
, stdenv
, fetchFromGitHub
, clang-unwrapped
, cmake
, libclang
, libffi
, libxml2
, llvm
, sphinx
, zlib
, withManual ? true
, withHTML ? true
}:

stdenv.mkDerivation rec {
  pname = "CastXML";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MschwCEkZrZmNgr8a1ocdukjXzHbXl2gmkPmygJaA6k=";
  };

  nativeBuildInputs = [
    cmake
    llvm
  ] ++ lib.optionals (withManual || withHTML) [
    sphinx
  ];

  cmakeFlags = [
    "-DCLANG_RESOURCE_DIR=${clang-unwrapped}/lib/clang/${lib.getVersion clang-unwrapped}/"
    "-DSPHINX_HTML=${if withHTML then "ON" else "OFF"}"
    "-DSPHINX_MAN=${if withManual then "ON" else "OFF"}"
  ];

  buildInputs = [
    clang-unwrapped
    libffi
    libxml2
    zlib
  ];

  propagatedBuildInputs = [
    libclang
  ];

  # 97% tests passed, 97 tests failed out of 2881
  # mostly because it checks command line and nix append -isystem and all
  doCheck = false;
  # -E exclude 4 tests based on names
  # see https://github.com/CastXML/CastXML/issues/90
  checkPhase = ''
    runHook preCheck
    ctest -E 'cmd.cc-(gnu|msvc)-((c-src-c)|(src-cxx))-cmd'
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/CastXML/CastXML";
    description = "C-family Abstract Syntax Tree XML Output";
    license = licenses.asl20;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
