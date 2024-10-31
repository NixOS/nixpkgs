{ lib, stdenv
, fetchurl
, zlib
}:

stdenv.mkDerivation rec {
  pname = "cramfsprogs";
  version = "1.1";

  src = fetchurl {
    url = "mirror://debian/pool/main/c/cramfs/cramfs_${version}.orig.tar.gz";
    sha256 = "0s13sabykbkbp0pcw8clxddwzxckyq7ywm2ial343ip7qjiaqg0k";
  };

  # CramFs is unmaintained upstream: https://tracker.debian.org/pkg/cramfs.
  # So patch the "missing include" bug ourselves.
  patches = [ ./include-sysmacros.patch ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    install --target $out/bin -D cramfsck mkcramfs
  '';

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Tools to create, check, and extract content of CramFs images";
    homepage = "https://packages.debian.org/jessie/cramfsprogs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pamplemousse ];
    platforms = platforms.linux;
  };
}
