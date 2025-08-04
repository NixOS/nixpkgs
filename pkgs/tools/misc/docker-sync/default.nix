{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "docker-sync";
  gemdir = ./.;

  inherit ruby;

  exes = [ "docker-sync" ];

  passthru.updateScript = bundlerUpdateScript "docker-sync";

  meta = {
    description = "Run your application at full speed while syncing your code for development";
    homepage = "http://docker-sync.io";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      manveru
      nicknovitski
    ];
    platforms = lib.platforms.unix;
    mainProgram = "docker-sync";
  };
}
