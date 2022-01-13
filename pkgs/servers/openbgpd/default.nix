{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, m4, bison }:

stdenv.mkDerivation rec {
  pname = "openbgpd";
  version = "7.2";

  src = fetchFromGitHub {
    owner = "openbgpd-portable";
    repo = "openbgpd-portable";
    rev = version;
    sha256 = "sha256-Q0hnDeGcCOhXAe1j3VRKt7q6hRcjgt8dqa3EoxTuHiI=";
  };

  nativeBuildInputs = [ autoconf automake libtool m4 bison ];

  # Merge the OpenBSD and portable trees and apply portablity patches.
  preConfigure = let
    openbsd-src = fetchFromGitHub {
      name = "portable";
      owner = "openbgpd-portable";
      repo = "openbgpd-openbsd";
      rev = "openbgpd-${version}";
      sha256 = "sha256-kflTy6+2TrkP/hn4xjyeSeTbDLGvCKoJ8n5toRkAYFw=";
    };
  in ''
    mkdir ./openbsd
    cp -r ${openbsd-src}/* ./openbsd/
    chmod -R +w ./openbsd
    ./autogen.sh
  '';

  meta = with lib; {
    description =
      "A free implementation of the Border Gateway Protocol, Version 4. It allows ordinary machines to be used as routers exchanging routes with other systems speaking the BGP protocol";
    license = licenses.isc;
    homepage = "http://www.openbgpd.org/";
    maintainers = with maintainers; [ kloenk ];
    platforms = platforms.linux;
  };
}
