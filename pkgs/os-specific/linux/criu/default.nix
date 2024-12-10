{
  stdenv,
  lib,
  fetchFromGitHub,
  protobuf,
  protobufc,
  asciidoc,
  iptables,
  xmlto,
  docbook_xsl,
  libpaper,
  libnl,
  libcap,
  libnet,
  pkg-config,
  iproute2,
  gzip,
  which,
  python3,
  makeWrapper,
  docbook_xml_dtd_45,
  perl,
  nftables,
  libbsd,
  gnutar,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "criu";
  version = "3.19";

  src = fetchFromGitHub {
    owner = "checkpoint-restore";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S0nxBHfm7tWmW5PhSDhSAgy1uDa0RD5GTNpMDUHKqwY=";
  };

  enableParallelBuilding = true;
  depsBuildBuild = [
    protobufc
    buildPackages.stdenv.cc
  ];
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
  propagatedBuildInputs =
    [
      protobufc
    ]
    ++ (with python3.pkgs; [
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

  makeFlags =
    let
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
    in
    [
      "PREFIX=$(out)"
      "ASCIIDOC=${buildPackages.asciidoc}/bin/asciidoc"
      "XMLTO=${buildPackages.xmlto}/bin/xmlto"
    ]
    ++ (lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      "ARCH=${linuxArchMapping."${stdenv.hostPlatform.linuxArch}"}"
      "CROSS_COMPILE=${stdenv.hostPlatform.config}-"
    ]);

  outputs = [
    "out"
    "dev"
    "man"
  ];

  preBuild = ''
    # No idea why but configure scripts break otherwise.
    export SHELL=""
  '';

  hardeningDisable = [
    "stackprotector"
    "fortify"
  ];
  # dropping fortify here as well as package uses it by default:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]

  postFixup = ''
    wrapProgram $out/bin/criu \
      --set-default CR_IPTABLES ${iptables}/bin/iptables \
      --set-default CR_IP_TOOL ${iproute2}/bin/ip \
      --prefix PATH : ${
        lib.makeBinPath [
          gnutar
          gzip
        ]
      }
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Userspace checkpoint/restore for Linux";
    homepage = "https://criu.org";
    license = licenses.gpl2;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "armv7l-linux"
    ];
    maintainers = [ maintainers.thoughtpolice ];
  };
}
