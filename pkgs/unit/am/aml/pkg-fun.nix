{ lib, stdenv, fetchFromGitHub, meson, pkg-config, ninja }:

stdenv.mkDerivation rec {
  pname = "aml";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WhhjK9uzKyvnzpGtAWXXo0upfZTPINHVk0qmzNXwobE=";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];

  meta = with lib; {
    description = "Another main loop";
    inherit (src.meta) homepage;
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
    broken = stdenv.isDarwin;
  };
}
