{ stdenv, lib, util-linux, fetchFromGitHub, bash, coreutils, ethtool, gnugrep, makeWrapper }:
let
  version = "20211028.00";
in stdenv.mkDerivation {
  inherit version;
  pname = "guest-configs";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "guest-configs";
    rev = version;
    sha256 = "sha256-0SRu6p/DsHNNI20mkXJitt/Ee5S2ooiy5hNmD+ndecM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/udev $out/bin

    # allows to install the package in `services.udev.packages` in NixOS
    cp -r "src/lib/udev/rules.d" $out/lib/udev
    cp "src/lib/udev/google_nvme_id" $out/bin
    cp "src/usr/bin/google_set_multiqueue" $out/bin

    # sysctl snippets will be used by google-compute-config.nix
    cp -r "src/etc/sysctl.d" $out

    runHook postInstall
  '';

  preFixup = ''
    wrapProgram $out/bin/google_set_multiqueue \
        --prefix "PATH" ":" "${lib.makeBinPath [ coreutils ethtool gnugrep ]}"

    for rules in $out/lib/udev/*.rules; do
      substituteInPlace "$rules" \
        --replace /bin/sh "${bash}/bin/bash" \
        --replace /bin/umount "${util-linux}/bin/umount" \
        --replace /usr/bin/logger "${util-linux}/bin/logger"
    done

    patchShebangs $out/bin/*
  '';

  meta = with lib; {
    description = "Linux Guest Environment for Google Compute Engine";
    homepage = "https://github.com/GoogleCloudPlatform/guest-configs";
    license = licenses.asl20;
    maintainers = with maintainers; [ mrkkrp ];
    platforms = platforms.linux;
  };
}
