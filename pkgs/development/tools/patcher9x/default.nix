{ fasm, lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation (finalAttr: {
  name = "patcher9x";
  version = "0.8.50";

  srcs = [
    (fetchFromGitHub {
      owner = "JHRobotics";
      repo = "patcher9x";
      rev = "v${finalAttr.version}";
      hash = "sha256-TZw2+R7Dzojzxzal1Wp8jhe5gwU4CfZDROITi5Z+auo=";
      name = "src";
    })

    (fetchFromGitHub {
      owner = "JHRobotics";
      repo = "nocrt";
      rev = "f65cc7ef2a3cccd6264b2eb265d7fffbecb06ba4";
      hash = "sha256-oeHcK9zYMDWk5sWfzYqLtC3MAJVtcaDJy4PvUGrxiPE=";
      name = "nocrt";
    })
  ];

  buildInputs = [ fasm ];
  sourceRoot = "src";
  hardeningDisable = [ "fortify" ];

  preBuild = ''
    rmdir nocrt
    ln -s ../nocrt .
  '';

  installPhase = ''
    runHook preInstall
    install -D patcher9x $out/bin/patcher9x
    runHook postInstall
  '';

  meta = with lib; {
    description = "Patch for Windows 95/98/98 SE/Me to fix CPU issues";
    homepage = "https://github.com/JHRobotics/patcher9x";
    license = licenses.mit;
    maintainers = with maintainers; [ hughobrien ];
    platforms = platforms.linux;
  };
})
