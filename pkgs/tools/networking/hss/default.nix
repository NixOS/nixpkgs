{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "hss-${version}";
  version = "1.0.1";

  gemdir = ./.;

  meta = with lib; {
    description = ''
      A SSH helper that uses regex and fancy expansion to dynamically manage SSH shortcuts.
    '';
    homepage    = https://github.com/akerl/hss;
    license     = licenses.mit;
    maintainers = with maintainers; [ nixy ];
    platforms   = platforms.unix;
  };
}
