{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "pisces";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "laughedelic";
    repo = "pisces";
    tag = "v${version}";
    hash = "sha256-Oou2IeNNAqR00ZT3bss/DbhrJjGeMsn9dBBYhgdafBw=";
  };

  meta = {
    description = "Paired symbols in the command line";
    homepage = "https://github.com/laughedelic/pisces";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ vanilla ];
  };
}
