{ lib
, stdenv
, fetchFromGitHub
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
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VtkMjZOcF5OAHkezlupXOpNwqUD1oKHdRbtG2FZBRL4=";
  };

  nativeBuildInputs = [
    cmake
    llvm.dev
  ] ++ lib.optionals (withManual || withHTML) [
    sphinx
  ];

  buildInputs = [
    libclang
    libffi
    libxml2
    zlib
  ];

  propagatedBuildInputs = [
    libclang
  ];

  cmakeFlags = [
    "-DCLANG_RESOURCE_DIR=${libclang.dev}/"
    "-DSPHINX_HTML=${if withHTML then "ON" else "OFF"}"
    "-DSPHINX_MAN=${if withManual then "ON" else "OFF"}"
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
