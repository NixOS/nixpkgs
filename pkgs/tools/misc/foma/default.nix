{ lib, stdenv, fetchFromGitHub, zlib, flex, bison, readline, darwin }:

stdenv.mkDerivation rec {
  pname = "foma";
  version = "0.10.0alpha";

  src = fetchFromGitHub {
    owner = "mhulden";
    repo = "foma";
    rev = "82f9acdef234eae8b7619ccc3a386cc0d7df62bc";
    sha256 = "1vf01l18j8cksnavbabcckp9gg692w6v5lg81xrzv6f5v14zp4nr";
  };

  sourceRoot = "${src.name}/foma";

  nativeBuildInputs = [ flex bison ]
    ++ lib.optional stdenv.isDarwin darwin.cctools;
  buildInputs = [ zlib readline ];

  makeFlags = [
    "CC:=$(CC)"
    "RANLIB:=$(RANLIB)"
    "prefix=$(out)"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "AR:=$(AR)" # libtool is used for darwin
  ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace '-ltermcap' ' '
  '';

  meta = with lib; {
    description = "A multi-purpose finite-state toolkit designed for applications ranging from natural language processing to research in automata theory";
    homepage = "https://github.com/mhulden/foma";
    license = licenses.asl20;
    maintainers = [ maintainers.tckmn ];
    platforms = platforms.all;
  };
}
