{ lib, stdenv, fetchFromGitHub, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "pflask";
  version = "unstable-2018-01-23";

  src = fetchFromGitHub {
    owner = "ghedo";
    repo = pname;
    rev = "9ac31ffe2ed29453218aac89ae992abbd6e7cc69";
    hash = "sha256-bAKPUj/EipZ98kHbZiFZZI3hLVMoQpCrYKMmznpSDhg=";
  };

  nativeBuildInputs = [ python3 wafHook ];

  postInstall = ''
    mkdir -p $out/bin
    cp build/pflask $out/bin
  '';

  meta = {
    description = "Lightweight process containers for Linux";
    homepage = "https://ghedo.github.io/pflask/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
