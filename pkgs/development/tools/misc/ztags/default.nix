{ lib
, stdenv
, fetchFromGitHub
, scdoc
, zig_0_11
}:

stdenv.mkDerivation {
  pname = "ztags";
  version = "unstable-2023-09-07";

  src = fetchFromGitHub {
    owner = "gpanders";
    repo = "ztags";
    rev = "6cdbd6dcdeda0d1ab9ad30261000e3d21b2407e6";
    hash = "sha256-lff5L7MG8RJdJM/YebJKDkKfkG4oumC0HytiCUOUG5Q=";
  };

  nativeBuildInputs = [
    scdoc
    zig_0_11.hook
  ];

  postInstall = ''
    zig build docs --prefix $out
  '';

  meta = with lib; {
    description = "Generate tags files for Zig projects";
    homepage = "https://github.com/gpanders/ztags";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ztags";
    inherit (zig_0_11.meta) platforms;
  };
}
