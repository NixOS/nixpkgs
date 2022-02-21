{ lib
, stdenv
, fetchFromGitHub
, guile
, autoreconfHook
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "scheme-bytestructures";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "TaylanUB";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7zglWQchKUaJemCUtOCICQPLrkDPGYJpGybhWiWQG0c=";
  };

  postConfigure = ''
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/godir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
  '';

  nativeBuildInputs = [
    autoreconfHook pkg-config
  ];
  buildInputs = [
    guile
  ];

  meta = with lib; {
    description = "Structured access to bytevector contents";
    homepage = "https://github.com/TaylanUB/scheme-bytestructures";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
  };
}
