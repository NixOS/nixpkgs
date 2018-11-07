{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, libyamlcpp, systemd
, asciidoctor, python3Packages
}:

stdenv.mkDerivation rec {
  name = "ip2unix-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nixcloud";
    repo = "ip2unix";
    rev = "v${version}";
    sha256 = "11scvwbnwivvsp2c9vfwzgmd3gprnhj9y170594bc3iisbdlj69k";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig asciidoctor
    python3Packages.pytest python3Packages.pytest-timeout
  ];

  buildInputs = [ libyamlcpp systemd ];

  doCheck = true;

  meta = {
    homepage = https://github.com/nixcloud/ip2unix;
    description = "Turn IP sockets into Unix domain sockets";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
  };
}
