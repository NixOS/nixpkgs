{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  pname = "mcfgthreads";
  version = "git"; # unstable-2021-03-12, not in any branch

  src = fetchFromGitHub {
    owner = "lhmouse";
    repo = "mcfgthread";
    rev = "c446cf4fcdc262fc899a188a4bb7136284c34222";
    sha256 = "1ib90lrd4dz8irq4yvzwhxqa86i5vxl2q2z3z04sf1i8hw427p2f";
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
