{stdenv, lib, fetchFromGitHub, libX11, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "xsel-unstable-${version}";

  version = "2016-09-02";

  src = fetchFromGitHub {
    owner = "kfish";
    repo = "xsel";
    rev = "aa7f57eed805adb09e9c59c8ea841870e8206b81";
    sha256 = "04mrc8j0rr7iy1k6brfxnx26pmxm800gh4nqrxn6j2lz6vd5y9m5";
  };

  buildInputs = [ libX11 autoreconfHook ];

  # We need a README file, otherwise autoconf complains.
  postUnpack = ''
    mv $sourceRoot/README{.md,}
  '';

  meta = with lib; {
    description = "Command-line program for getting and setting the contents of the X selection";
    homepage = http://www.kfish.org/software/xsel;
    license = licenses.mit;
    maintainers = [ maintainers.cstrahan ];
    platforms = lib.platforms.unix;
  };
}
