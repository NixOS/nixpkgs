{ lib
, stdenvNoCC
, fetchFromGitHub
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
stdenvNoCC.mkDerivation rec {
  pname = "xvfb-run";
  version = "1+g87f6705";

  src = fetchFromGitHub {
    owner = "archlinux";
    repo = "svntogit-packages";
    rev = "87f67054c49b32511893acd22be94c47ecd44b4a";
    sha256 = "sha256-KEg92RYgJd7naHFDKbdXEy075bt6NLcmX8VhQROHVPs=";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/trunk/xvfb-run $out/bin/xvfb-run
    installManPage $src/trunk/xvfb-run.1

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
    license = licenses.gpl2Only;
    maintainers = [ maintainers.artturin ];
    mainProgram = "xvfb-run";
  };
}
