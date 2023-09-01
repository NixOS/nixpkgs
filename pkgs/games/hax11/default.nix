{ lib
, multiStdenv
, fetchFromGitHub
, glibc
, pkgs
}:

multiStdenv.mkDerivation {
  pname = "hax11";

  src = fetchFromGitHub {
    owner = "ayham-1";
    repo = "hax11";
    rev = "fd2fc5c88ae45161ad67500d74cec018c02b9bc1";
    sha256 = "1kc0rnips5640pqk6rxjvrd1ssgzgvivimck9ajl4kjm6yvc0l6m";
  };

  strictDeps = true;

  buildInputs = with pkgs; [
    gcc
    glibc
    xorg.gccmakedep
    xorg.xorgproto
    xorg.libXxf86vm
    xorg.libX11
    xorg.libXi
    xorg.libXxf86vm
  ];

  outputs = [ "out" ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Hackbrary to Hook and Augment X11 protocol calls";
    homepage = "https://github.com/ayham-1/hax11";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ ayham ];
  };
}
