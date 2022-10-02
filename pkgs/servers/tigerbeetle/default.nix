{ lib
, stdenv
, fetchFromGitHub
, zig_0_9
}:
stdenv.mkDerivation rec {
  pname = "tigerbeetle";
  version = "2023-02-13-weekly";

  src = fetchFromGitHub {
    owner = "tigerbeetledb";
    repo = "tigerbeetle";
    rev = version;
    hash = "sha256-OcVLFnzW140Drx/jQ6p3eW1ZDGXrRSM6eQ47L+Ub54A=";
  };

  nativeBuildInputs = [ zig_0_9 ];

  buildPhase = ''
    runHook preBuild

    export HOME="$(mktemp -d)"
    zig build -Dcpu=baseline -Drelease-safe

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv zig-out/bin/tigerbeetle $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "A distributed financial accounting database designed for mission critical safety and performance";
    homepage = "https://github.com/tigerbeetledb/tigerbeetle";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
