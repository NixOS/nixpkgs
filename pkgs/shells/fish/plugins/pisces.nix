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
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Oou2IeNNAqR00ZT3bss/DbhrJjGeMsn9dBBYhgdafBw=";
  };

  meta = with lib; {
    description = "Paired symbols in the command line";
    homepage = "https://github.com/laughedelic/pisces";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ vanilla ];
  };
}
