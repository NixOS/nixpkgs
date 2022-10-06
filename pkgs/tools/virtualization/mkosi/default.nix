{ lib
, fetchFromGitHub
, python3
, stdenv
, glibc
, glib
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mkosi";
  version = "13";
  format = "setuptools";

  #src = fetchFromGitHub {
  #  owner = "systemd";
  #  repo = "mkosi";
  #  rev = "v${version}";
  #  hash = "sha256-4eBxxCPpMcbnTtGpYw0FuxdNZ7sxSbaaavoJZ6Kboa0=";
  #};
  src = /home/onny/projects/mkosi;
  unpackPhase = ''cp -r --no-preserve=mode $src/* .'';

  # Fix ctypes finding library
  # https://github.com/NixOS/nixpkgs/issues/7307
  patchPhase = lib.optionalString stdenv.isLinux ''
    substituteInPlace mkosi/__init__.py --replace \
      'ctypes.util.find_library("c")' "'${stdenv.cc.libc}/lib/libc.so.6'"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    pexpect
  ];

  postInstall = ''
    wrapProgram $out/bin/mkosi \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  disabledTests = [
    "test_os_distribution"
    "test_centos_brtfs"
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Build legacy-free OS images";
    homepage = "https://github.com/systemd/mkosi";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ onny ];
  };
}
