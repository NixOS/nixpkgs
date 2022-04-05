{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "musl-obstack";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "musl-obstack";
    rev = "v${version}";
    sha256 = "sha256-oydS7FubUniMHAUWfg84OH9+CZ0JCrTXy7jzwOyJzC8=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/void-linux/musl-obstack";
    description =
      "An extraction of the obstack functions and macros from GNU libiberty for use with musl-libc";
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.pjjw ];
  };
}
