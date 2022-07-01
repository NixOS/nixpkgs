{ stdenv
, lib
, fetchurl
, dpkg
, writeShellScript
, curl
, jq
, common-updater-scripts
}:

let
  version = "2.8.1";

  sources = {
    "x86_64-linux" = fetchurl {
      url = "https://packages.blackfire.io/debian/pool/any/main/b/blackfire/blackfire_${version}_amd64.deb";
      sha256 = "znaM00jM6yrpb+bGTxzJUxViCUzv4G+CYK2EB5dxhfY=";
    };
    "i686-linux" = fetchurl {
      url = "https://packages.blackfire.io/debian/pool/any/main/b/blackfire/blackfire_${version}_i386.deb";
      sha256 = "QIY4qGm333H5MWhe3CIfEieqTEk8st5A7SJHkwGnnxw=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://packages.blackfire.io/debian/pool/any/main/b/blackfire/blackfire_${version}_arm64.deb";
      sha256 = "eZbKoKYC2tt4Rxn5OJr7iA1aJlYFC0tpRmbLq7qSrIU=";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://packages.blackfire.io/blackfire/${version}/blackfire-darwin_arm64.pkg.tar.gz";
      sha256 = "tn2vF3v7KfF7CfWqyydL5Iyh5tP9Tez87PJH+URgSIw=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://packages.blackfire.io/blackfire/${version}/blackfire-darwin_amd64.pkg.tar.gz";
      sha256 = "CRFlnqpX4j2CMGzS+UvXwNty2mHpONOjym6UJPE2Yg4=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "blackfire";
  inherit version;

  src = sources.${stdenv.hostPlatform.system};

  nativeBuildInputs = lib.optionals stdenv.isLinux [ dpkg ];

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
    updateScript = writeShellScript "update-${pname}" ''
      set -o errexit
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      NEW_VERSION=$(curl -s https://blackfire.io/api/v1/releases | jq .cli --raw-output)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for platform in ${lib.concatStringsSep " " meta.platforms}; do
        update-source-version "blackfire" "0" "${lib.fakeSha256}" "--system=$platform"
        update-source-version "blackfire" "$NEW_VERSION" "--system=$platform" --ignore-same-hash
      done
    '';
  };

  meta = with lib; {
    description = "Blackfire Profiler agent and client";
    homepage = "https://blackfire.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ jtojnar shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
