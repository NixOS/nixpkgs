{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, systemd
}:

stdenv.mkDerivation rec {
  pname = "keyd";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    rev = "v" + version;
    hash = "sha256-QWr+xog16MmybhQlEWbskYa/dypb9Ld54MOdobTbyMo=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace DESTDIR= DESTDIR=${placeholder "out"} \
      --replace /usr "" \
      --replace /var/log/keyd.log /var/log/keyd/keyd.log

    substituteInPlace keyd.service \
      --replace /usr/bin $out/bin
  '';

  buildInputs = [ systemd ];

  enableParallelBuilding = true;

  postInstall = ''
    rm -rf $out/etc
  '';

  meta = with lib; {
    description = "A key remapping daemon for linux.";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
