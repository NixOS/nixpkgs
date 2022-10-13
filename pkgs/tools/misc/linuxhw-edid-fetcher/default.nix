{ lib
, coreutils
, fetchFromGitHub
, gawk
, stdenv
, unixtools
, writeShellApplication
, displays ? { } # { PG278Q_2014 = [ "PG278Q" "2014" ]; }
}:

# Usage:
#   let
#     edids = (linuxhw-edid-generator.override {
#       displays = {
#         PG278Q_2014 = [ "PG278Q" "2014" ];
#       };
#     });
#   in
#     "${edids}/lib/firmware/edid/PG278Q_2014.bin";
let
  revision = "228fea5d89782402dd7f84a459df7f5248573b10";

  src = fetchFromGitHub {
    owner = "linuxhw";
    repo = "EDID";
    rev = revision;
    sha256 = "sha256-HFyu/WFKGLxL1iz6wqOREpXME1PK1xcxx0ewdhf8Eac=";
  };

  fetcher = writeShellApplication {
    name = "linuxhw-edid-fetcher";
    runtimeInputs = [ gawk coreutils unixtools.xxd ];
    text = ''
      cd '${src}'
      ${builtins.readFile ./linuxhw-edid-fetcher.sh}
    '';
  };

  bin = "${fetcher}/bin/linuxhw-edid-fetcher";
in
stdenv.mkDerivation {
  pname = "linuxhw-edid-fetcher";
  version = revision;
  inherit src;

  configurePhase = lib.pipe displays [
    (lib.mapAttrsToList (name: patterns: "${bin} ${lib.escapeShellArgs patterns} > '${name}.bin'"))
    (lines: [ "set -x" ] ++ lines ++ [ "set +x" ])
    (builtins.concatStringsSep "\n")
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    ln -s "${bin}" "$out/bin"
    install -Dm 444 *.bin -t "$out/lib/firmware/edid"
  '';

  meta = {
    description = "Fetcher for EDID binaries from Linux Hardware Project's EDID repository";
    homepage = "https://github.com/linuxhw/EDID";
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [ nazarewk ];
    platforms = lib.platforms.all;
  };
}
