{ lib
, stdenv
, autoPatchelfHook
, fetchzip
}:

let
  archNameMapping = {
    i686 = "386";
    x86_64 = "amd64";
    aarch64 = "arm";
    armv5tel = "arm";
    armv6l = "arm";
    armv7a = "arm";
    armv7l = "arm";
  };
  archName = archNameMapping.${stdenv.targetPlatform.uname.processor};
  kernelName = stdenv.targetPlatform.parsed.kernel.name;
in

stdenv.mkDerivation rec {
  pname = "one-password";
  version = "1.8.0";

  nativeBuildInputs = [ autoPatchelfHook ];

  src = fetchzip {
    url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_${kernelName}_${archName}_v${version}.zip";
    sha256 = "1651ricswsdq9yi742k4403qar7cvfc2glr4wr2glga7f891spax";
    postFetch = ''
      mkdir $out
      cd $out

      unzip $downloadedFile
      rm -rf op.sig
    '';
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/op $out/bin/op
  '';

  meta = with lib; {
    description = "1Password command line tool";
    homepage = "https://1password.com/downloads/command-line/";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
    platforms = [
      "x86_64-darwin"

      "i686-freebsd"
      "x86_64-freebsd"

      "i686-linux"
      "x86_64-linux"

      "aarch64-linux"
      "armv5tel-linux"
      "armv6l-linux"
      "armv7a-linux"
      "armv7l-linux"

      "i686-openbsd"
      "x86_64-openbsd"
    ];
    changelog = "https://app-updates.agilebits.com/product_history/CLI";
  };
}
