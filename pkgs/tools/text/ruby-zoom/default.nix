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

  meta = with lib; {
    description = "Quickly open CLI search results in your favorite editor";
    homepage = "https://gitlab.com/mjwhitta/zoom";
    license = with licenses; gpl3;
    maintainers = with maintainers; [
      vmandela
      nicknovitski
    ];
    platforms = platforms.unix;
  };
}
