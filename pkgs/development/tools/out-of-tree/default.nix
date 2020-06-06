{ stdenv, buildGoModule, fetchgit, qemu, docker, which, makeWrapper }:

buildGoModule rec {
  pname = "out-of-tree";
  version = "1.3.0";

  buildInputs = [ makeWrapper ];

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "https://code.dumpstack.io/tools/${pname}.git";
    sha256 = "02xh23nbwyyf087jqkm97jbnwpja1myaz190q5r166mpwcdpz2dn";
  };

  vendorSha256 = "1dk0cipdgj2yyg1bc9l7nvy4y373pmqwy8xiyc0wg7pchb4h9p7s";

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
