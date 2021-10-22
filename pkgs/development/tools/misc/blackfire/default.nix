{ stdenv
, lib
, fetchurl
, dpkg
, autoPatchelfHook
, writeShellScript
, curl
, jq
, common-updater-scripts
}:

stdenv.mkDerivation rec {
  pname = "blackfire";
  version = "2.5.1";

  src = fetchurl {
    url = "https://packages.blackfire.io/debian/pool/any/main/b/blackfire/blackfire_${version}_amd64.deb";
    sha256 = "wak7LE5j6OKIHqCsEGrxSq1FAFzehMetYj6c/Zkr9dk=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    dpkg-deb -x $src $out
    mv $out/usr/* $out
    rmdir $out/usr

    # Fix ExecStart path and replace deprecated directory creation method,
    # use dynamic user.
    substituteInPlace "$out/lib/systemd/system/blackfire-agent.service" \
      --replace '/usr/' "$out/" \
      --replace 'ExecStartPre=/bin/mkdir -p /var/run/blackfire' 'RuntimeDirectory=blackfire' \
      --replace 'ExecStartPre=/bin/chown blackfire: /var/run/blackfire' "" \
      --replace 'User=blackfire' 'DynamicUser=yes' \
      --replace 'PermissionsStartOnly=true' ""

    # Modernize socket path.
    substituteInPlace "$out/etc/blackfire/agent" \
      --replace '/var/run' '/run'

    runHook postInstall
  '';

  passthru = {
    updateScript = writeShellScript "update-${pname}" ''
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      update-source-version "$UPDATE_NIX_ATTR_PATH" "$(curl https://blackfire.io/api/v1/releases | jq .cli --raw-output)"
    '';
  };

  meta = with lib; {
    description = "Blackfire Profiler agent and client";
    homepage = "https://blackfire.io/";
    license = licenses.unfree;
    maintainers = with maintainers; [ jtojnar ];
    platforms = [ "x86_64-linux" ];
  };
}
