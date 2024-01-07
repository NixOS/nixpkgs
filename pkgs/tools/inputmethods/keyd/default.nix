{ stdenv
, lib
, fetchFromGitHub
, systemd
, runtimeShell
, python3
, nixosTests
, makeWrapper
}:

let
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    rev = "v" + version;
    hash = "sha256-NhZnFIdK0yHgFR+rJm4cW+uEhuQkOpCSLwlXNQy6jas=";
  };

  pypkgs = python3.pkgs;

  appMap = pypkgs.buildPythonApplication rec {
    pname = "keyd-application-mapper";
    inherit version src;
    format = "other";

    postPatch = ''
      substituteInPlace scripts/${pname} \
        --replace /bin/sh ${runtimeShell}
      substituteInPlace scripts/${pname} \
        --replace "CONFIG_PATH = os.getenv('HOME')+'/.config/keyd/app.conf'" "CONFIG_PATH = '/etc/keyd/application-mapper/app.conf'"
      substituteInPlace scripts/${pname} \
        --replace "LOCKFILE = os.getenv('HOME')+'/.config/keyd/app.lock'" "LOCKFILE = '/etc/keyd/application-mapper/app.lock'"
      substituteInPlace scripts/${pname} \
        --replace "LOGFILE = os.getenv('HOME')+'/.config/keyd/app.log'" "LOGFILE = '/etc/keyd/application-mapper/app.log'"
      substituteInPlace scripts/${pname} \
        --replace "~/.config/keyd/app.conf" "/etc/keyd/application-mapper/app.conf"
    '';

    propagatedBuildInputs = with pypkgs; [ xlib ];

    dontBuild = true;

    installPhase = ''
      install -Dm555 -t $out/bin scripts/${pname}
    '';

    meta.mainProgram = "keyd-application-mapper";
  };

in
stdenv.mkDerivation {
  pname = "keyd";
  inherit version src;

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr ""

    substituteInPlace keyd.service \
      --replace /usr/bin $out/bin
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  buildInputs = [ systemd ];

  nativeBuildInputs = [ makeWrapper ];

  enableParallelBuilding = true;

  # post-2.4.2 may need this to unbreak the test
  # makeFlags = [ "SOCKET_PATH/run/keyd/keyd.socket" ];

  postInstall = ''
    makeWrapper ${appMap}/bin/${appMap.pname} $out/bin/keyd-application-mapper
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
