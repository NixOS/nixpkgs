{ stdenv, fetchurl, makeWrapper, writeShellScript, lib, php, curl, jq, common-updater-scripts }:

let
  pname = "platformsh";
  version = "v3.78.0";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/platformsh/platformsh-cli/releases/download/${version}/platform.phar";
    sha256 = "sha256-2EasMsZIwplkl1S5PH0Y3gRymAIdpiFgVc3pNPiFg1o=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/platformsh/platform.phar
    makeWrapper ${php}/bin/php $out/bin/platform \
      --add-flags "$out/libexec/platformsh/platform.phar"
    runHook postInstall
  '';

  passthru = {
      updateScript = writeShellScript "update-${pname}" ''
        set -o errexit
        export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
        NEW_VERSION=$(curl -s https://api.github.com/repos/platformsh/platformsh-cli/releases/latest | jq .tag_name --raw-output)

        if [[ "${version}" = "$NEW_VERSION" ]]; then
            echo "The new version same as the old version."
            exit 0
        fi

        update-source-version "platformsh" "$NEW_VERSION"
      '';
    };

  meta = with lib; {
    description = "The unified tool for managing your Platform.sh services from the command line.";
    license = licenses.mit;
    homepage = "https://github.com/platformsh/platformsh-cli";
    maintainers = with maintainers; [ shyim ];
    platforms = platforms.all;
  };
}
