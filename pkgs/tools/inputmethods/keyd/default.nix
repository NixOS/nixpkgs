{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, systemd
, runtimeShell
, python3
, nixosTests
}:

let
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    rev = "v" + version;
    hash = "sha256-QWr+xog16MmybhQlEWbskYa/dypb9Ld54MOdobTbyMo=";
  };

  pypkgs = python3.pkgs;

  appMap = pypkgs.buildPythonApplication rec {
    pname = "keyd-application-mapper";
    inherit version src;
    format = "other";

    postPatch = ''
      substituteInPlace scripts/${pname} \
        --replace /bin/sh ${runtimeShell}
    '';

    propagatedBuildInputs = with pypkgs; [ xlib ];

    dontBuild = true;

    installPhase = ''
      install -Dm555 -t $out/bin scripts/${pname}
    '';

    meta.mainProgram = pname;
  };

in
stdenv.mkDerivation rec {
  pname = "keyd";
  inherit version src;

  postPatch = ''
    substituteInPlace Makefile \
      --replace DESTDIR= DESTDIR=${placeholder "out"} \
      --replace /usr ""

    substituteInPlace keyd.service \
      --replace /usr/bin $out/bin
  '';

  buildInputs = [ systemd ];

  enableParallelBuilding = true;

  # post-2.4.2 may need this to unbreak the test
  # makeFlags = [ "SOCKET_PATH/run/keyd/keyd.socket" ];

  postInstall = ''
    ln -sf ${lib.getExe appMap} $out/bin/${appMap.pname}
    rm -rf $out/etc
  '';

  passthru.tests.keyd = nixosTests.keyd;

  meta = with lib; {
    description = "A key remapping daemon for linux.";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
