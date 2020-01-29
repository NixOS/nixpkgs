{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  pname = "mcfgthreads";
  version = "git";

  src = fetchFromGitHub {
    owner = "lhmouse";
    repo = "mcfgthread";
    rev = "9570e5ca7b98002d707c502c919d951bf256b9c6";
    sha256 = "10y2x3x601a7c1hkd6zlr3xpfsnlr05xl28v23clf619756a5755";
  };

  outputs = [ "out" "dev" ];

  # Don't want prebuilt binaries sneaking in.
  postUnpack = ''
    rm -r "$sourceRoot/debug" "$sourceRoot/release"
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];
}
