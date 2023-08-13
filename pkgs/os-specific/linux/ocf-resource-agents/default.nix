# This combines together OCF definitions from other derivations.
# https://github.com/ClusterLabs/resource-agents/blob/master/doc/dev-guides/ra-dev-guide.asc
{ stdenv
, lib
, runCommand
, lndir
, fetchFromGitHub
, autoreconfHook
, pkg-config
, python3
, glib
, drbd
, iproute2
, gawk
, coreutils
, pacemaker
}:

let
  drbdForOCF = drbd.override {
    forOCF = true;
  };
  pacemakerForOCF = pacemaker.override {
    forOCF = true;
  };

  resource-agentsForOCF = stdenv.mkDerivation rec {
    pname = "resource-agents";
    version = "4.10.0";

    src = fetchFromGitHub {
      owner = "ClusterLabs";
      repo = pname;
      rev = "v${version}";
      sha256 = "0haryi3yrszdfpqnkfnppxj1yiy6ipah6m80snvayc7v0ss0wnir";
    };

    patches = [ ./improve-command-detection.patch ];

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
    ];

    buildInputs = [
      glib
      python3
    ];

    # Note using wrapProgram had issues with the findif.sh script So insert an
    # updated PATH after the shebang with what it needs to run instead.
    #
    # substituteInPlace also had issues.
    #
    # edits to ocf-binaries are a minimum to get ocf:heartbeat:IPaddr2 to function
    postInstall = ''
      sed -i '1 iPATH=$PATH:${iproute2}/bin:${gawk}/bin:${coreutils}/bin' $out/lib/ocf/lib/heartbeat/findif.sh
      patchShebangs $out/lib/ocf/lib/heartbeat
      sed -i -e "s|AWK:=.*|AWK:=${gawk}/bin/awk}|" $out/lib/ocf/lib/heartbeat/ocf-binaries
      sed -i -e "s|IP2UTIL:=ip|IP2UTIL:=${iproute2}/bin/ip}|" $out/lib/ocf/lib/heartbeat/ocf-binaries
    '';

    env.NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12") [
      # Needed with GCC 12 but breaks on darwin (with clang) or older gcc
      "-Wno-error=maybe-uninitialized"
    ]);

    meta = with lib; {
      homepage = "https://github.com/ClusterLabs/resource-agents";
      description = "Combined repository of OCF agents from the RHCS and Linux-HA projects";
      license = licenses.gpl2Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [ ryantm astro ];
    };
  };

in

# This combines together OCF definitions from other derivations.
# https://github.com/ClusterLabs/resource-agents/blob/master/doc/dev-guides/ra-dev-guide.asc
runCommand "ocf-resource-agents" {} ''
  mkdir -p $out/usr/lib/ocf
  ${lndir}/bin/lndir -silent "${resource-agentsForOCF}/lib/ocf/" $out/usr/lib/ocf
  ${lndir}/bin/lndir -silent "${drbdForOCF}/usr/lib/ocf/" $out/usr/lib/ocf
  ${lndir}/bin/lndir -silent "${pacemakerForOCF}/usr/lib/ocf/" $out/usr/lib/ocf
''
