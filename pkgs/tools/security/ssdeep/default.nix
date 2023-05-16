{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "ssdeep";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "ssdeep-project";
    repo = "ssdeep";
    rev = "release-${version}";
    sha256 = "1yx6yjkggshw5yl89m4kvyzarjdg2l3hs0bbjbrfzwp1lkfd8i0c";
  };

  nativeBuildInputs = [ autoreconfHook ];

<<<<<<< HEAD
  # remove forbidden references to $TMPDIR
  preFixup = lib.optionalString stdenv.isLinux ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$out"/bin/*
  '';
=======
  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "A program for calculating fuzzy hashes";
    homepage    = "http://www.ssdeep.sf.net";
    license     = lib.licenses.gpl2;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
