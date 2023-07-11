{ stdenv, lib, fetchFromGitHub, fetchpatch, protobuf, protobufc, asciidoc, iptables
, xmlto, docbook_xsl, libpaper, libnl, libcap, libnet, pkg-config, iproute2, gzip
, which, python3, makeWrapper, docbook_xml_dtd_45, perl, nftables, libbsd, gnutar
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "criu";
  version = "3.17.1";

  src = fetchFromGitHub {
    owner = "checkpoint-restore";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0B0cdX5bemy4glF9iWjrQIXIqilyYcCcAN9x4Jjrwzk=";
  };

  patches = [
    # Fixes redefinition of rseq headers
    (fetchpatch {
      url = "https://github.com/checkpoint-restore/criu/commit/1e6e826ffb7ac05f33fa123051c2fc2ddf0f68ea.patch";
      hash = "sha256-LJjk0jQ5v5wqeprvBMpxhjLXn7v+lSPldEGgazGUM44=";
    })

    # compat fixes for glibc-2.36
    (fetchpatch {
      url = "https://github.com/checkpoint-restore/criu/commit/8cd5fccd6cf3d03afb5abe463134d31f54d42258.patch";
      sha256 = "sha256-b65DdLmyIuZik0dNRuWJKUPcDFA6CKq0bi4Vd26zgS4=";
    })
    (fetchpatch {
      url = "https://github.com/checkpoint-restore/criu/commit/517c0947050e63aac72f63a3bf373d76264723b9.patch";
      sha256 = "sha256-MPZ6oILVoZ7BQEZFjUlp3RuMC7iKTKXAtrUDFqbN4T8=";
    })
  ];

  enableParallelBuilding = true;
  depsBuildBuild = [ protobufc buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    pkg-config
    asciidoc
    xmlto
    libpaper
    docbook_xsl
    which
    makeWrapper
    docbook_xml_dtd_45
    python3
    python3.pkgs.wrapPython
    perl
  ];
  buildInputs = [
    protobuf
    libnl
    libcap
    libnet
    nftables
    libbsd
  ];
  propagatedBuildInputs = [
    protobufc
  ] ++ (with python3.pkgs; [
    python
    python3.pkgs.protobuf
  ]);

  postPatch = ''
    substituteInPlace ./Documentation/Makefile \
      --replace "2>/dev/null" "" \
      --replace "-m custom.xsl" "-m custom.xsl --skip-validation -x ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
    substituteInPlace ./Makefile --replace "head-name := \$(shell git tag -l v\$(CRIU_VERSION))" "head-name = ${version}.0"
    ln -sf ${protobuf}/include/google/protobuf/descriptor.proto ./images/google/protobuf/descriptor.proto
  '';

  makeFlags = let
    # criu's Makefile infrastructure expects to be passed a target architecture
    # which neither matches the config-tuple's first part, nor the
    # targetPlatform.linuxArch attribute. Thus we take the latter and map it
    # onto the expected string:
    linuxArchMapping = {
      "x86_64" = "x86";
      "arm" = "arm";
      "arm64" = "aarch64";
      "powerpc" = "ppc64";
      "s390" = "s390";
      "mips" = "mips";
    };
  in [
    "PREFIX=$(out)"
    "ASCIIDOC=${buildPackages.asciidoc}/bin/asciidoc"
    "XMLTO=${buildPackages.xmlto}/bin/xmlto"
  ] ++ (lib.optionals (stdenv.buildPlatform != stdenv.targetPlatform) [
    "ARCH=${linuxArchMapping."${stdenv.targetPlatform.linuxArch}"}"
    "CROSS_COMPILE=${stdenv.targetPlatform.config}-"
  ]);

  outputs = [ "out" "dev" "man" ];

  preBuild = ''
    # No idea why but configure scripts break otherwise.
    export SHELL=""
  '';

  hardeningDisable = [ "stackprotector" "fortify" ];
  # dropping fortify here as well as package uses it by default:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]

  postFixup = ''
    wrapProgram $out/bin/criu \
      --set-default CR_IPTABLES ${iptables}/bin/iptables \
      --set-default CR_IP_TOOL ${iproute2}/bin/ip \
      --prefix PATH : ${lib.makeBinPath [ gnutar gzip ]}
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Userspace checkpoint/restore for Linux";
    homepage    = "https://criu.org";
    license     = licenses.gpl2;
    platforms   = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
    maintainers = [ maintainers.thoughtpolice ];
  };
}
