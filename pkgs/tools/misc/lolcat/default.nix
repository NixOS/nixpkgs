{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "${pname}-${version}";
  pname = "lolcat";
  version = (import ./gemset.nix).lolcat.version;

  inherit ruby;

  # expects Gemfile, Gemfile.lock and gemset.nix in the same directory
  gemdir = ./.;

  meta = with lib; {
    description = "A rainbow version of cat";
    homepage    = https://github.com/busyloop/lolcat;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ StillerHarpo ];
  };
}
