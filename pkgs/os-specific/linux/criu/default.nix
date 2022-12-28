{ stdenv, lib, fetchFromGitHub, fetchpatch, protobuf, protobufc, asciidoc, iptables
, xmlto, docbook_xsl, libpaper, libnl, libcap, libnet, pkg-config, iproute2
, which, python3, makeWrapper, docbook_xml_dtd_45, perl, nftables, libbsd }:

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
  ];

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config docbook_xsl which makeWrapper docbook_xml_dtd_45 python3 python3.pkgs.wrapPython perl ];
  buildInputs = [ protobuf asciidoc xmlto libpaper libnl libcap libnet nftables libbsd ];
  propagatedBuildInputs = [ protobufc ] ++ (with python3.pkgs; [ python python3.pkgs.protobuf ]);

  postPatch = ''
    substituteInPlace ./Documentation/Makefile \
      --replace "2>/dev/null" "" \
      --replace "-m custom.xsl" "-m custom.xsl --skip-validation -x ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
    substituteInPlace ./Makefile --replace "head-name := \$(shell git tag -l v\$(CRIU_VERSION))" "head-name = ${version}.0"
    ln -sf ${protobuf}/include/google/protobuf/descriptor.proto ./images/google/protobuf/descriptor.proto
  '';

  makeFlags = [ "PREFIX=$(out)" "ASCIIDOC=${asciidoc}/bin/asciidoc" "XMLTO=${xmlto}/bin/xmlto" ];

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
      --set-default CR_IP_TOOL ${iproute2}/bin/ip
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Userspace checkpoint/restore for Linux";
    homepage    = "https://criu.org";
    license     = licenses.gpl2;
    platforms   = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = [ maintainers.thoughtpolice ];
  };
}
