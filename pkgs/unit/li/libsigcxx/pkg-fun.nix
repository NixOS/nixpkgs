{ lib, stdenv, fetchurl, pkg-config, meson, ninja, gnome }:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "2.10.8";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-I1pAvsc0bHuCtqjKrgRWNT3AbnHxS8QUvMhYrxg4cZo=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "libsigcxx";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    description = "A typesafe callback system for standard C++";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
