{
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  ruby,
}:

bundlerEnv {
  pname = "compass";
  version = "1.0.3";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "compass";

  meta = {
    description = "Stylesheet Authoring Environment that makes your website design simpler to implement and easier to maintain";
    homepage = "https://github.com/Compass/compass";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [
      offline
      manveru
      nicknovitski
    ];
    mainProgram = "compass";
    platforms = lib.platforms.unix;
  };
}
