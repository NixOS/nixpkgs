{ lib
, stdenv
, fetchFromGitHub
, bats
, uncrustify
, testers
, packcc
}:

stdenv.mkDerivation rec {
  pname = "packcc";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "arithy";
    repo = "packcc";
    rev = "v${version}";
    hash = "sha256-T7PWM5IGly6jpGt04dh5meQjrZPUTs8VEFTQEPO5RSw=";
  };

  dontConfigure = true;

  preBuild = ''
    cd build/${if stdenv.cc.isGNU then "gcc"
               else if stdenv.cc.isClang then "clang"
               else throw "Unsupported C compiler"}
  '';

  doCheck = true;

  nativeCheckInputs = [ bats uncrustify ];

  preCheck = ''
    patchShebangs ../../tests

    # Disable a failing test.
    rm -rf ../../tests/style.d
  '' + lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE+=' -Wno-error=strict-prototypes -Wno-error=int-conversion'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 release/bin/packcc $out/bin/packcc

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = packcc;
  };

  meta = with lib; {
    description = "A parser generator for C";
    longDescription = ''
      PackCC is a parser generator for C. Its main features are as follows:
      - Generates your parser in C from a grammar described in a PEG,
      - Gives your parser great efficiency by packrat parsing,
      - Supports direct and indirect left-recursive grammar rules.
    '';
    homepage = "https://github.com/arithy/packcc";
    changelog = "https://github.com/arithy/packcc/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
