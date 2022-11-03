{ lib, buildGoModule, fetchgit, qemu, docker, which, makeWrapper, updateGolangSysHook }:

buildGoModule rec {
  pname = "out-of-tree";
  version = "1.4.0";

  nativeBuildInputs = [ makeWrapper updateGolangSysHook ];

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "https://code.dumpstack.io/tools/${pname}.git";
    sha256 = "1rn824l3dzh3xjxsbzzj053qg1abhzjimc8l73r0n5qrl44k2qk2";
  };

  vendorSha256 = "sha256-uUEx/4ea43Ri3i3tRh5IJBjIiKZmSOzVjuc/ixU7EDc=";

  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/out-of-tree \
      --prefix PATH : "${lib.makeBinPath [ qemu docker which ]}"
  '';

  meta = with lib; {
    description = "kernel {module, exploit} development tool";
    homepage = "https://out-of-tree.io";
    maintainers = [ maintainers.dump_stack ];
    license = licenses.agpl3Plus;
  };
}
