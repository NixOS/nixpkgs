{ lib
, stdenvNoCC
, fetchFromGitLab
, makeWrapper
, xorgserver
, getopt
, xauth
, util-linux
, which
, fontsConf
, gawk
, coreutils
, installShellFiles
, xterm
}:
stdenvNoCC.mkDerivation {
  pname = "xvfb-run";
  version = "1+g842f671";

  src = fetchFromGitLab {
    domain = "gitlab.archlinux.org";
    owner = "archlinux";
    repo = "packaging/packages/xorg-server";
    rev = "842f671c8b950e599a327e9abd4f01f65301203f";
    sha256 = "sha256-2wy95ngMxNiZVMko0SVYi2bNR8y50hmFHyS+gpt4sd0=";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/xvfb-run $out/bin/xvfb-run
    installManPage $src/xvfb-run.1

    chmod a+x $out/bin/xvfb-run
    patchShebangs $out/bin/xvfb-run
    wrapProgram $out/bin/xvfb-run \
      --set-default FONTCONFIG_FILE "${fontsConf}" \
      --prefix PATH : ${lib.makeBinPath [ getopt xorgserver xauth which util-linux gawk coreutils ]}
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    (
      unset PATH
      echo "running xterm with xvfb-run"
      $out/bin/xvfb-run ${lib.getBin xterm}/bin/xterm -e true
    )
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Convenience script to run a virtualized X-Server";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.artturin ];
    mainProgram = "xvfb-run";
  };
}
