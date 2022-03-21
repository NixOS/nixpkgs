{ stdenv, lib, fetchFromGitHub, cmake, bash-completion, pkg-config, libconfig
, asciidoc
, libusbgx
}:
stdenv.mkDerivation {
  pname = "gt";
  version = "unstable-2021-09-30";

  src = fetchFromGitHub {
    owner = "linux-usb-gadgets";
    repo = "gt";
    rev = "7247547a14b2d092dc03fd83218ae65c2f7ff7d6";
    sha256 = "1has9q2sghd5vyi25l3h2hd4d315vvpld076iwwsg01fx4d9vjmg";
  };
  sourceRoot = "source";

  preConfigure = ''
    cmakeFlagsArray+=("-DBASH_COMPLETION_COMPLETIONSDIR=$out/share/bash-completions/completions")
  '';
  nativeBuildInputs = [ cmake pkg-config asciidoc ];
  buildInputs = [ bash-completion libconfig libusbgx];

  meta = {
    description = "Linux command line tool for setting up USB gadgets using configfs";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ lheckemann ];
    platforms = lib.platforms.linux;
  };
}
