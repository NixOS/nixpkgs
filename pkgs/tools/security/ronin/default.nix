{
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  defaultGemConfig,
  yasm,
}:

bundlerEnv {
  name = "ronin";
  gemdir = ./.;

  gemConfig = defaultGemConfig // {
    ronin-code-asm = attrs: {
      dontBuild = false;
      postPatch = ''
        substituteInPlace lib/ronin/code/asm/program.rb \
          --replace "YASM::Command.run(" "YASM::Command.run(
          command_path: '${yasm}/bin/yasm',"
      '';
    };
  };

  postBuild = ''
    shopt -s extglob
    rm $out/bin/!(ronin*)
  '';

  passthru.updateScript = bundlerUpdateScript "ronin";

  meta = with lib; {
    description = "Free and Open Source Ruby toolkit for security research and development";
    homepage = "https://ronin-rb.dev";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Ch1keen ];
  };
}
