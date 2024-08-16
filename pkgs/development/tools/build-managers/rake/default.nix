{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "rake";
  gemdir = ./.;
  exes = [ "rake" ];

  passthru.updateScript = bundlerUpdateScript "rake";

  meta = with lib; {
    description = "Software task management and build automation tool";
    homepage = "https://github.com/ruby/rake";
    license  = with licenses; mit;
    maintainers = with maintainers; [ manveru nicknovitski ];
    platforms = platforms.unix;
    mainProgram = "rake";
  };
}
