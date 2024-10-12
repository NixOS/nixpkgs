{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  stdenv,

  libdaemon,
  libnl,
  jansson,
  pkg-config
}:

stdenv.mkDerivation rec {
  pname = "teamd";
  version = "1.31";
  outputs = ["dev" "lib" "man" "out"];

  buildInputs = [libdaemon libnl jansson];
  nativeBuildInputs = [autoreconfHook pkg-config];

  src = fetchFromGitHub {
    owner = "jpirko";
    repo = "libteam";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-V1l0e84G7uRPEyw6BOOsd3MJ/HqMSkJ9HckpMP7LJ7s=";
  };

  meta = with lib; {
    description = "A library for controlling team network devices";
    homepage = "https://libteam.org";
    license = licenses.lgpl21;
    maintainers = [maintainers.agbrooks];
    platforms = platforms.linux;
  };
}
