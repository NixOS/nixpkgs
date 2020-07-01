{ buildSetupcfg, fetchFromGitHub, lib }:

buildSetupcfg rec {
  info = import ./info.nix;
  src = fetchFromGitHub {
    owner = "target";
    repo = "setupcfg2nix";
    rev = info.version;
    sha256 = "1rj227vxybwp9acwnpwg9np964b1qcw2av3qmx00isnrw5vcps8m";
  };
  application = true;
  meta = {
    description = "Generate nix expressions from setup.cfg for a python package.";
    homepage = "https://github.com/target/setupcfg2nix";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.shlevy ];
  };
}
