{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "austin";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "P403n1x87";
    repo = "austin";
    rev = "v${version}";
    sha256 = "12qy3qg7h51inj6sw19ncf6klw07mw55jxq3fv4anfi54b2kmz2r";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Python frame stack sampler for CPython";
    homepage = "https://github.com/P403n1x87/austin";
    maintainers = with maintainers; [ gunnar ];
    license = licenses.gpl3Plus;
  };
}
