{ lib
, stdenvNoCC
, fetchFromGitHub
, btrfs-progs
, coreutils
, findutils
, gnugrep
, gnused
, makeWrapper
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "btrfsmaintenance";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "kdave";
    repo = "btrfsmaintenance";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wD9AWOaYtCZqU2YIxO6vEDIHCNQBygvFzRHW3LOQRqk=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    btrfs-progs
    coreutils
    findutils
    gnused
    gnugrep
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 sysconfig.btrfsmaintenance "$out/etc/default/btrfsmaintenance"
    install -dm755 "$out/"{usr/lib/systemd/system,usr/share/btrfsmaintenance}
    install -Dm755 btrfs-*.sh btrfsmaintenance-{functions,refresh-cron.sh} README.md "$out/usr/share/btrfsmaintenance"
    install -Dm644 *.service *.timer *.path "$out/usr/lib/systemd/system"

    runHook postInstall
  '';

  postFixup = ''
    for f in $out/usr/share/btrfsmaintenance/*; do
      substituteInPlace $f \
        --replace "PATH=/sbin:/bin:/usr/sbin:/usr/bin" "" \
        --replace "export PATH" "" \
        --replace "$(dirname $(realpath "$0"))/btrfsmaintenance-functions" ". $out/usr/share/btrfsmaintenance/btrfsmaintenance-functions"

      wrapProgram $f --prefix PATH : ${lib.makeBinPath finalAttrs.buildInputs}
    done
  '';

  # Just a collection of scripts and systemd services
  dontConfigure = true;
  dontBuild = true;

  meta = {
    description = "A set of scripts supplementing the btrfs filesystem and aims to automate a few maintenance tasks";
    homepage = "https://github.com/kdave/btrfsmaintenance";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.linux;
  };
})
