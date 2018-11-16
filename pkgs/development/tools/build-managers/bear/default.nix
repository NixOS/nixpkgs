{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  name = "bear-${version}";
  version = "2.3.13";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = "Bear";
    rev = version;
    sha256 = "0imvvs22gyr1v6ydgp5yn2nq8fb8llmz0ra1m733ikjaczl3jm7z";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ python ]; # just for shebang of bin/bear

  doCheck = false; # all fail

  patches = [ ./ignore_wrapper.patch ./cmakepaths.patch ];

  meta = with stdenv.lib; {
    description = "Tool that generates a compilation database for clang tooling";
    longDescription = ''
      Note: the bear command is very useful to generate compilation commands
      e.g. for YouCompleteMe.  You just enter your development nix-shell
      and run `bear make`.  It's not perfect, but it gets a long way.
    '';
    homepage = https://github.com/rizsotto/Bear;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat maintainers.babariviere ];
  };
}
