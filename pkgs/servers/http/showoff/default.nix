{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "showoff";
  gemdir = ./.;
  exes = [ "showoff" ];

  passthru.updateScript = bundlerUpdateScript "showoff";

  meta = with lib; {
    description = "A slideshow presentation tool with a twist";
    longDescription = "It runs as a web application, with audience interactivity features. This means that your audience can follow along in their own browsers, can download supplemental materials, can participate in quizzes or polls, post questions for the presenter, etc. By default, their slideshows will synchronize with the presenter, but they can switch to self-navigation mode";
    homepage = "https://puppetlabs.github.io/showoff/";
    license = with licenses; mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      maxwilson
      nicknovitski
    ];
  };
}
