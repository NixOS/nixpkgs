{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, zig
}:

stdenv.mkDerivation rec {
  pname = "linuxwave";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "linuxwave";
    rev = "v${version}";
    hash = "sha256-JWVQSMJNtZvs8Yg8bUM6Sb9YMt8KGElunQVIK2mUrhE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    installShellFiles
    zig
  ];

  postConfigure = ''
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  buildPhase = ''
    runHook preBuild

    zig build -Drelease-safe -Dcpu=baseline

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    zig build test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    zig build -Drelease-safe -Dcpu=baseline --prefix $out install

    installManPage man/linuxwave.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Generate music from the entropy of Linux";
    homepage = "https://github.com/orhun/linuxwave";
    changelog = "https://github.com/orhun/linuxwave/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.all;
  };
}
