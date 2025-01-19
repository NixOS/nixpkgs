{
  lib,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
}:

bundlerEnv {
  pname = "ruby-zoom";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "ruby-zoom";

  meta = {
    description = "Quickly open CLI search results in your favorite editor";
    homepage = "https://gitlab.com/mjwhitta/zoom";
    license = with lib.licenses; gpl3;
    maintainers = with lib.maintainers; [
      vmandela
      nicknovitski
    ];
    platforms = lib.platforms.unix;
  };
}
