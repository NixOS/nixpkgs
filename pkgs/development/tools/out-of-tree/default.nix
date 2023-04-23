{ lib, buildGoModule, fetchgit, qemu, docker, which, makeWrapper }:

buildGoModule rec {
  pname = "out-of-tree";
  version = "2.0.4";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "https://code.dumpstack.io/tools/${pname}.git";
    sha256 = "sha256-D2LiSDnF7g1h0XTulctCnZ+I6FZSLA0XRd9LQLOMP9c=";
  };

  vendorSha256 = "sha256-p1dqzng3ak9lrnzrEABhE1TP1lM2Ikc8bmvp5L3nUp0=";

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
