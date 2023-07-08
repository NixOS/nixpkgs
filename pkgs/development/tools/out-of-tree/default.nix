{ lib, buildGoModule, fetchFromGitHub, qemu, makeWrapper }:

buildGoModule rec {
  pname = "out-of-tree";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "out-of-tree";
    repo = "out-of-tree";
    rev = "v${version}";
    hash = "sha256-FXB3HM73sYKFaXrwOXXPVnsTGyZPHzU6Kf7JRAV2Cpw=";
  };

  vendorHash = "sha256-p1dqzng3ak9lrnzrEABhE1TP1lM2Ikc8bmvp5L3nUp0=";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/out-of-tree \
      --prefix PATH : "${lib.makeBinPath [ qemu ]}"
  '';

  meta = with lib; {
    description = "kernel {module, exploit} development tool";
    homepage = "https://out-of-tree.io";
    maintainers = [ maintainers.dump_stack ];
    license = licenses.agpl3Plus;
  };
}
