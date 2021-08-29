{ lib, stdenv, fetchgit, asciidoc, docbook_xsl, libxslt }:
stdenv.mkDerivation rec {
  pname = "trace-cmd";
  version = "2.9.1";

  src = fetchgit {
    url    = "git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/";
    rev    = "trace-cmd-v${version}";
    sha256 = "19c63a0qmcppm1456qf4k6a0d1agcvpa6jnbzrdcyc520yax6khw";
  };

  patches = [ ./fix-Makefiles.patch ];

  nativeBuildInputs = [ asciidoc libxslt ];

  outputs = [ "out" "lib" "dev" "man" ];

  MANPAGE_DOCBOOK_XSL="${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";

  dontConfigure = true;

  buildPhase = "make trace-cmd libs doc";

  installTargets = [ "install_cmd" "install_libs" "install_doc" ];
  installFlags = [
    "bindir=${placeholder "out"}/bin"
    "man_dir=${placeholder "man"}/share/man"
    "libdir=${placeholder "lib"}/lib"
    "includedir=${placeholder "dev"}/include"
    "BASH_COMPLETE_DIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "User-space tools for the Linux kernel ftrace subsystem";
    homepage    = "https://kernelshark.org/";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice basvandijk ];
  };
}
