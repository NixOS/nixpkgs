{
  stdenv,
  lib,
  fetchFromGitHub,
  bash,
  coreutils,
  dtc,
  file,
  gawk,
  gnugrep,
  gnused,
  pandoc,
  which,
}:

stdenv.mkDerivation rec {
  pname = "restool";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "nxp-qoriq";
    repo = "restool";
    rev = "abd2f5b7181db9d03db9e6ccda0194923b73e9a2";
    sha256 = "sha256-ryTDyqSy39e8Omf7l8lK4mLWr8jccDhMVPldkVGSQVo=";
  };

  nativeBuildInputs = [
    file
    pandoc
  ];
  buildInputs = [
    bash
    coreutils
    dtc
    gawk
    gnugrep
    gnused
    which
  ];

  enableParallelBuilding = true;
  makeFlags = [
    "prefix="
    "bindir_completion=/share/bash-completion/completions"
    "DESTDIR=$(out)"
    "VERSION=${version}"
  ];

  postPatch = ''
    # -Werror makes this derivation fragile on compiler version upgrades, patch
    # it out.
    sed -i /-Werror/d Makefile
  '';

  preFixup = ''
    # wrapProgram interacts badly with the ls-main tool, which relies on the
    # shell's $0 argument to figure out which operation to run (busybox-style
    # symlinks). Instead, inject the environment directly into the shell
    # scripts we need to wrap.
    for tool in ls-append-dpl ls-debug ls-main; do
      sed -i "1 a export PATH=\"$out/bin:${lib.makeBinPath buildInputs}:\$PATH\"" $out/bin/$tool
    done
  '';

  meta = with lib; {
    description = "DPAA2 Resource Management Tool";
    longDescription = ''
      restool is a user space application providing the ability to dynamically
      create and manage DPAA2 containers and objects from Linux.
    '';
    homepage = "https://github.com/nxp-qoriq/restool";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
