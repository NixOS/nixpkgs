{ lib, ruby, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "docker-sync";
  gemdir = ./.;

  inherit ruby;

  exes = ["docker-sync"];

  passthru.updateScript = bundlerUpdateScript "docker-sync";

  meta = with lib; {
    description = "Run your application at full speed while syncing your code for development";
    homepage = "http://docker-sync.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ manveru nicknovitski ];
    platforms = platforms.unix;
    mainProgram = "docker-sync";
  };
}
