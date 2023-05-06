{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  testers,
  zf,
}:
stdenv.mkDerivation rec {
  pname = "zf";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "natecraddock";
    repo = pname;
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-MzlSU5x2lb6PJZ/iNAi2aebfuClBprlfHMIG/4OPmuc=";
  };

  nativeBuildInputs = [ zig ];

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline --prefix $out install
    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {package = zf;};

  meta = with lib; {
    homepage = "https://github.com/natecraddock/zf";
    description = "A commandline fuzzy finder that prioritizes matches on filenames";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dit7ya mmlb ];
  };
}
