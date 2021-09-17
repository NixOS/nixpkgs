{ lib
, stdenv
, fetchFromGitHub
, fish
, runtimeShell
, writeShellScript
}:

stdenv.mkDerivation rec {
  pname = "oh-my-fish";
  version = "7+unstable=2021-03-03";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "0b1396ad7962073fa25615bf03c43b53eddc2d56";
    hash = "sha256-lwMo4+PcYR9kYJPWK+ALiMfBdxFSgB2vjtSn8QrmmEA=";
  };

  buildInputs = [
    fish
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/bin $out/share/${pname}
    cp -vr * $out/share/${pname}

    cat << EOF > $out/bin/omf-install
    #!${runtimeShell}

    ${fish}/bin/fish \\
      $out/share/${pname}/bin/install \\
      --noninteractive \\
      --offline=$out/share/${pname}

    EOF
    chmod +x $out/bin/omf-install

    runHook PostInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/oh-my-fish/oh-my-fish";
    description = "The Fish Shell Framework";
    longDescription = ''
      Oh My Fish provides core infrastructure to allow you to install packages
      which extend or modify the look of your shell. It's fast, extensible and
      easy to use.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = fish.meta.platforms;
  };
}
# TODO: customize the omf-install script
