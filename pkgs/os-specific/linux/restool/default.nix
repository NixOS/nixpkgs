{ stdenv, lib, fetchgit, bash, coreutils, dtc, file, gawk, gnugrep, gnused }:

stdenv.mkDerivation rec {
  pname = "restool";
  version = "20.12";

  src = fetchgit {
    url = "https://source.codeaurora.org/external/qoriq/qoriq-components/restool";
    rev = "LSDK-${version}";
    sha256 = "137xvvms3n4wwb5v2sv70vsib52s3s314306qa0mqpgxf9fb19zl";
  };

  nativeBuildInputs = [ file ];
  buildInputs = [ bash coreutils dtc gawk gnugrep gnused ];

  makeFlags = [
    "prefix=$(out)"
    "VERSION=${version}"
  ];

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
    homepage = "https://source.codeaurora.org/external/qoriq/qoriq-components/restool/about/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
  };
}
