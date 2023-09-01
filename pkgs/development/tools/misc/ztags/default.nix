{ lib
, stdenv
, fetchFromGitHub
, zig_0_11
}:

stdenv.mkDerivation {
  pname = "ztags";
  version = "unstable-2023-08-29";

  src = fetchFromGitHub {
    owner = "gpanders";
    repo = "ztags";
    rev = "87dbc4ba7993fa1537ddce942c6ce4cf90ce0809";
    hash = "sha256-FZZZnTmz4mxhiRXs16A41fz0WYIg6oGM7xj2cECRkrM=";
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
