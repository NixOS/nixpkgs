{ stdenv, fetchFromGitHub, binutils-unwrapped, patchelf, asterisk }:
stdenv.mkDerivation rec {
  pname = "asterisk-module-sccp";
  version = "4.3.2-epsilon";

  src = fetchFromGitHub {
    owner = "chan-sccp";
    repo = "chan-sccp";
    rev = "v${version}";
    sha256 = "0sp74xvb35m32flsrib0983yn1dyz3qk69vp0gqbx620ycbz19gd";
  };

  nativeBuildInputs = [ patchelf ];

  configureFlags = [ "--with-asterisk=${asterisk}" ];

  installFlags = [ "DESTDIR=/build/dest" "DATAROOTDIR=/build/dest" ];

  postInstall = ''
    mkdir -p "$out"
    cp -r /build/dest/${asterisk}/* "$out"
  '';

  postFixup = ''
    p="$out/lib/asterisk/modules/chan_sccp.so"
    patchelf --set-rpath "$p:${stdenv.lib.makeLibraryPath [ binutils-unwrapped ]}" "$p"
  '';

  meta = with stdenv.lib; {
    description = "Replacement for the SCCP channel driver in Asterisk";
    license = licenses.gpl1Only;
    maintainers = with maintainers; [ das_j ];
  };
}
