{ lib
, stdenv
, fetchFromGitHub
, zig
}:
stdenv.mkDerivation rec {
  pname = "zf";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "natecraddock";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-XxNMm4NKQOJ4U4xspoonnruXRSGz3rSEdZJclfub/f0=";
  };

  nativeBuildInputs = [ zig ];

  buildPhase = ''
    runHook preBuild

    export HOME="$(mktemp -d)"
    zig build -Drelease-fast=true

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp zig-out/bin/zf $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/natecraddock/zf";
    description = "A commandline fuzzy finder that prioritizes matches on filenames";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
  };
}
