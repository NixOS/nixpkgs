{ buildSetupcfg, fetchFromGitHub, lib }:

buildSetupcfg rec {
  info = import ./info.nix;
  src = fetchFromGitHub {
    owner = "target";
    repo = "setupcfg2nix";
    rev = info.version;
    sha256 = "1zn9njpzwhwikrirgjlyz6ys3xr8gq61ry8blmnpscqvhsdhxcs6";
  };
  application = true;
  meta = {
    description = "Generate nix expressions from setup.cfg for a python package.";
    homepage = https://github.com/target/setupcfg2nix;
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.shlevy ];
  };
}
