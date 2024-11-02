{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libX11 }:

stdenv.mkDerivation rec {
  pname = "xsettingsd";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "derat";
    repo = "xsettingsd";
    rev = "v${version}";
    sha256 = "sha256-CIYshZqJICuL8adKHIN4R6nudaqWOCK2UPrGhsKf9pE=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libX11 ];

  # we end up with symlinked unit files if we don't move them around ourselves
  postFixup = ''
    rm -r $out/lib/systemd
    mv $out/share/systemd $out/lib
  '';

  meta = with lib; {
    description = "Provides settings to X11 applications via the XSETTINGS specification";
    homepage = "https://github.com/derat/xsettingsd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ romildo ];
    platforms = platforms.linux;
    mainProgram = "xsettingsd";
  };
}
