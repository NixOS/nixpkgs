{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, liblxi, readline, lua
}:

stdenv.mkDerivation rec {
  pname = "lxi-tools";
  version = "1.21";

  src = fetchFromGitHub {
    owner = "lxi-tools";
    repo = "lxi-tools";
    rev = "v${version}";
    sha256 = "0rkp6ywsw2zv7hpbr12kba79wkcwqin7xagxxhd968rbfkfdxlwc";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ liblxi readline lua ];

  meta = with lib; {
    description = "Tool for communicating with LXI compatible instruments";
    longDescription = ''
      lxi-tools is a collection of open source software tools
      that enables control of LXI compatible instruments such
      as modern oscilloscopes, power supplies,
      spectrum analyzers etc.
    '';
    homepage = "https://lxi-tools.github.io/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.vq ];
  };
}
