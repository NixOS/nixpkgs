{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libX11,
  libXtst,
  xorgproto,
  libXi,
}:

stdenv.mkDerivation rec {
  pname = "xcape";
  version = "unstable-2018-03-01";

  src = fetchFromGitHub {
    owner = "alols";
    repo = pname;
    rev = "a34d6bae27bbd55506852f5ed3c27045a3c0bd9e";
    sha256 = "04grs4w9kpfzz25mqw82zdiy51g0w355gpn5b170p7ha5972ykc8";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    libXtst
    xorgproto
    libXi
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "MANDIR=/share/man/man1"
  ];

  postInstall = "install -Dm444 --target-directory $out/share/doc README.md";

  meta = with lib; {
    description = "Utility to configure modifier keys to act as other keys";
    longDescription = ''
      xcape allows you to use a modifier key as another key when
      pressed and released on its own.  Note that it is slightly
      slower than pressing the original key, because the pressed event
      does not occur until the key is released.  The default behaviour
      is to generate the Escape key when Left Control is pressed and
      released on its own.
    '';
    homepage = "https://github.com/alols/xcape";
    license = licenses.gpl3;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    mainProgram = "xcape";
  };
}
