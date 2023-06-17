{ lib
, stdenv
, fetchFromGitHub
, fish
, runtimeShell
, writeShellScript
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oh-my-fish";
  version = "unstable-2022-03-27";

  src = fetchFromGitHub {
    owner = finalAttrs.pname;
    repo = finalAttrs.pname;
    rev = "d428b723c8c18fef3b2a00b8b8b731177f483ad8";
    hash = "sha256-msItKEPe7uSUpDAfCfdYZjt5NyfM3KtOrLUTO9NGqlg=";
  };

  strictDeps = true;
  buildInputs = [
    fish
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/bin $out/share/${finalAttrs.pname}
    cp -vr * $out/share/${finalAttrs.pname}

    cat << EOF > $out/bin/omf-install
    #!${runtimeShell}

    ${fish}/bin/fish \\
      $out/share/${finalAttrs.pname}/bin/install \\
      --noninteractive \\
      --offline=$out/share/${finalAttrs.pname}

    EOF
    chmod +x $out/bin/omf-install

    runHook postInstall
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
    mainProgram = "omf-install";
    platforms = fish.meta.platforms;
  };
})
# TODO: customize the omf-install script
