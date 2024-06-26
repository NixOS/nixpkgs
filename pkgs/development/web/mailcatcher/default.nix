{
  ruby_3_2,
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "mailcatcher";
  gemdir = ./.;
  exes = [
    "mailcatcher"
    "catchmail"
  ];
  ruby = ruby_3_2;

  passthru.updateScript = bundlerUpdateScript "mailcatcher";

  meta = with lib; {
    description = "SMTP server and web interface to locally test outbound emails";
    homepage = "https://mailcatcher.me/";
    license = licenses.mit;
    maintainers = with maintainers; [
      zarelit
      nicknovitski
    ];
    platforms = platforms.unix;
  };
}
