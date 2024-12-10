{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libX11,
  libXt,
  libXpm,
  libXaw,
  localStateDir ? null,
}:

stdenv.mkDerivation {
  pname = "xjump";
  version = "2.9.3";
  src = fetchFromGitHub {
    owner = "hugomg";
    repo = "xjump";
    rev = "e7f20fb8c2c456bed70abb046c1a966462192b80";
    sha256 = "0hq4739cvi5a47pxdc0wwkj2lmlqbf1xigq0v85qs5bq3ixmq2f7";
  };
  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [
    libX11
    libXt
    libXpm
    libXaw
  ];
  preConfigure = "autoreconf --install";
  patches = lib.optionals stdenv.buildPlatform.isDarwin [ ./darwin.patch ];
  configureFlags = lib.optionals (localStateDir != null) [ "--localstatedir=${localStateDir}" ];

  meta = with lib; {
    description = "The falling tower game";
    mainProgram = "xjump";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pmeunier ];
  };
}
