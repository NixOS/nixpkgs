{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  testers,
  installShellFiles,
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

  nativeBuildInputs = [ zig installShellFiles ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  buildPhase = ''
    runHook preBuild
    zig build -Drelease-safe -Dcpu=baseline
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    zig build test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline --prefix $out install
    installManPage doc/zf.1
    installShellCompletion \
      --bash complete/zf \
      --fish complete/zf.fish \
      --zsh complete/_zf
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
