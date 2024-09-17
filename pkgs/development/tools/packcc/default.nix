{
  bats,
  fetchFromGitHub,
  lib,
  python3,
  stdenv,
  testers,
  uncrustify,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "packcc";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "arithy";
    repo = "packcc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k1C/thvr/5fYrgu/j8YN3kwXp4k26sC9AhYhYAKQuX0=";
  };

  postPatch = ''
    patchShebangs tests
  '';

  dontConfigure = true;

  preBuild = ''
    cd build/${
      if stdenv.cc.isGNU then
        "gcc"
      else if stdenv.cc.isClang then
        "clang"
      else
        throw "Unsupported C compiler"
    }
  '';

  doCheck = true;

  nativeCheckInputs = [
    bats
    uncrustify
    python3
  ];

  preCheck =
    ''
      # Style tests will always fail because upstream uses an older version of
      # uncrustify.
      rm -rf ../../tests/style.d
    ''
    + lib.optionalString stdenv.cc.isClang ''
      export NIX_CFLAGS_COMPILE+=' -Wno-error=strict-prototypes -Wno-error=int-conversion'
    '';

  installPhase = ''
    runHook preInstall
    install -Dm755 release/bin/packcc $out/bin/packcc
    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = with lib; {
    description = "Parser generator for C";
    longDescription = ''
      PackCC is a parser generator for C. Its main features are as follows:
      - Generates your parser in C from a grammar described in a PEG,
      - Gives your parser great efficiency by packrat parsing,
      - Supports direct and indirect left-recursive grammar rules.
    '';
    homepage = "https://github.com/arithy/packcc";
    changelog = "https://github.com/arithy/packcc/releases/tag/${finalAttrs.src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
    mainProgram = "packcc";
  };
})
