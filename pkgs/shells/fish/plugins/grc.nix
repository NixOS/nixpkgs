{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin {
  pname = "grc";
  version = "0-unstable-2022-05-24";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-grc";
    rev = "61de7a8a0d7bda3234f8703d6e07c671992eb079";
    sha256 = "sha256-NQa12L0zlEz2EJjMDhWUhw5cz/zcFokjuCK5ZofTn+Q=";
  };

  postInstall = ''
    cp conf.d/executables $out/share/fish/vendor_conf.d/
  '';

  meta = with lib; {
    description = "grc Colourizer for some commands on Fish shell";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
    platforms = with platforms; unix;
  };
}
