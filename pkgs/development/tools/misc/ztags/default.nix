{ lib
, stdenv
, fetchFromGitHub
, zig_0_11
}:

stdenv.mkDerivation {
  pname = "ztags";
  version = "unstable-2023-08-03";

  src = fetchFromGitHub {
    owner = "gpanders";
    repo = "ztags";
    rev = "6ef039047f6580772c5ff97e8770d919dc07a4fa";
    hash = "sha256-WuDEHzNU3I4VPHEAkRdIUE5LPbQEKbUnITdFutGV58Y=";
  };

  nativeBuildInputs = [
    zig_0_11.hook
  ];

  meta = with lib; {
    description = "Generate tags files for Zig projects";
    homepage = "https://github.com/gpanders/ztags";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ztags";
    inherit (zig_0_11.meta) platforms;
  };
}
