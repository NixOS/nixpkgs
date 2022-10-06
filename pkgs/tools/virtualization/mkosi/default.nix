{ lib
, fetchFromGitHub
, python3
, stdenv
, glibc
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

  propagatedBuildInputs = with python3.pkgs; [
    pexpect
  ];

  postInstall = ''
    wrapProgram $out/bin/mkosi \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix LD_LIBRARY_PATH :"${lib.makeLibraryPath [ stdenv.cc.libc.out glibc.out ]}"
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
