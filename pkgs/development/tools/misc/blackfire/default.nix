{ stdenv
, lib
, fetchurl
, dpkg
, writeShellScript
, curl
, jq
, common-updater-scripts
}:

stdenv.mkDerivation rec {
  pname = "blackfire";
  version = "2.27.0";

  src = passthru.sources.${stdenv.hostPlatform.system} or (throw "Unsupported platform for blackfire: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    dpkg
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    if ${ lib.boolToString stdenv.isLinux }
    then
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
    else
      mkdir $out

      tar -zxvf $src

      mv etc $out
      mv usr/* $out
    fi

    runHook postInstall
  '';

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://packages.blackfire.io/debian/pool/any/main/b/blackfire/blackfire_${version}_amd64.deb";
        sha256 = "4SFexvlmw6+ZI+cQAe9xIoeR43c8BG97v8A8oIB9fP4=";
      };
      "i686-linux" = fetchurl {
        url = "https://packages.blackfire.io/debian/pool/any/main/b/blackfire/blackfire_${version}_i386.deb";
        sha256 = "N34qScxL9JhqyUika2QIioW+dixxRMv9Y1Q0DaxIA80=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://packages.blackfire.io/debian/pool/any/main/b/blackfire/blackfire_${version}_arm64.deb";
        sha256 = "rZ+n9mJAL7CZR91+PxHt7oNZAfZnQKAqDSaU8z4ahS4=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://packages.blackfire.io/blackfire/${version}/blackfire-darwin_arm64.pkg.tar.gz";
        sha256 = "fHrgX6YFojEj+eD933WgR4DgIZmJupmHmdO3gHzQxSc=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://packages.blackfire.io/blackfire/${version}/blackfire-darwin_amd64.pkg.tar.gz";
        sha256 = "oxG/p946JettJZqEkmPWpfvLkLUg1FYA77hNdJ+jGfE=";
      };
    };

    updateScript = writeShellScript "update-blackfire" ''
      set -o errexit
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      NEW_VERSION=$(curl -s https://blackfire.io/api/v1/releases | jq .cli --raw-output)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for platform in ${lib.escapeShellArgs meta.platforms}; do
        update-source-version "blackfire" "0" "${lib.fakeSha256}" --source-key="sources.$platform"
        update-source-version "blackfire" "$NEW_VERSION" --source-key="sources.$platform"
      done
    '';
  };

  meta = with lib; {
    description = "Blackfire Profiler agent and client";
    homepage = "https://blackfire.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
