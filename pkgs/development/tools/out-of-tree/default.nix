{ stdenv, buildGoModule, fetchgit, qemu, docker, which, makeWrapper }:

buildGoModule rec {
  pname = "out-of-tree";
  version = "1.4.0";

  buildInputs = [ makeWrapper ];

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "https://code.dumpstack.io/tools/${pname}.git";
    sha256 = "1rn824l3dzh3xjxsbzzj053qg1abhzjimc8l73r0n5qrl44k2qk2";
  };

  vendorSha256 = "0kg5c4h7xnwfcfshrh5n76xv98wzr73kxzr8q65iphsjimbxcpy3";

  postFixup = ''
    wrapProgram $out/bin/out-of-tree \
      --prefix PATH : "${stdenv.lib.makeBinPath [ qemu docker which ]}"
  '';

  meta = with stdenv.lib; {
    description = "kernel {module, exploit} development tool";
    homepage = "https://out-of-tree.io";
    maintainers = [ maintainers.dump_stack ];
    license = licenses.agpl3Plus;
  };
}
