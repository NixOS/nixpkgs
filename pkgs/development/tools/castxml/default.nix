{ lib
, stdenv
, fetchFromGitHub
, cmake
, libffi
, libxml2
, zlib
, withManual ? true
, withHTML ? true
, llvmPackages
, python3
}:

let
  inherit (llvmPackages) libclang llvm;
  inherit (python3.pkgs) sphinx;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "castxml";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "CastXML";
    repo = "CastXML";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dyB2h6Yix2lZbVFVCz8nWNNubFSEVBlRpjVrBRec4Xo=";
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
})
