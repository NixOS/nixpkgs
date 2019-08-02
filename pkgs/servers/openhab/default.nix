{ stdenv
, lib
, fetchurl
, crudini
, makeWrapper
, unzip
, bluez
, gawk
, procps
, udev
, addons ? []
}:
let
  urls = { pname, version, ext }:
    let
      path = "org/openhab/distro/${pname}/${version}/${pname}-${version}.${ext}";
    in
      [
        "https://bintray.com/openhab/mvn/download_file?file_path=${path}"
        "https://openhab.jfrog.io/openhab/libs-milestone-local/${path}"
      ];

  addon = { pname, version, sha256 }: stdenv.mkDerivation rec {
    inherit pname version;

    src = fetchurl {
      urls = urls { inherit pname version; ext = "kar"; };
      inherit sha256;
    };

    buildCommand = ''
      install -Dm444 $src $out/share/java/${src.name}
    '';
  };

  generic = { version, sha256 }: stdenv.mkDerivation rec {
    pname = "openhab";
    inherit version;

    src = fetchurl {
      urls = urls { inherit pname version; ext = "zip"; };
      inherit sha256;
    };

    sourceRoot = ".";

    nativeBuildInputs = [ crudini makeWrapper unzip ];

    # log everything to stdout by default so we can use journalctl to query the logs
    postPatch = lib.concatMapStringsSep "\n" (
      e: ''
        crudini --set --inplace userdata/etc/org.ops4j.pax.logging.cfg \
          "" "${e.key}" "${e.value}"
      ''
    ) [
      { key = "log4j2.rootLogger.level"; value = "INFO"; }
      { key = "log4j2.rootLogger.appenderRefs"; value = "stdout"; }
      { key = "log4j2.rootLogger.appenderRef.stdout.ref"; value = "STDOUT"; }
      { key = "log4j2.appender.console.layout.pattern"; value = "<%level{FATAL=2, ERROR=3, WARN=4, INFO=5, DEBUG=6, TRACE=7}>[%-36.36c] - %m%n"; }
    ];

    dontConfigure = true;

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      dir=$out/share/openhab

      mkdir -p $out/bin $dir

      cp -r * $dir/

      ${lib.concatStringsSep "\n" (
      map (
        e: ''
          for f in ${e}/share/java/* ; do
            ln -s $f $dir/addons/
          done
        ''
      ) addons
    )}

      makeWrapper $out/share/openhab/runtime/bin/karaf $out/bin/openhab \
        --set-default OPENHAB_HOME $dir \
        --set-default OPENHAB_CONF /var/lib/openhab/conf \
        --set-default OPENHAB_USERDATA /var/lib/openhab/userdata \
        --set-default OPENHAB_LOGDIR /var/log/openhab \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ bluez udev ]} \
        --prefix PATH : /run/wrappers/bin:${lib.makeBinPath [ gawk procps ]}

      chmod 555 $out/bin/*

      runHook postInstall
    '';

    meta = with stdenv.lib; {
      description = "OpenHAB - vendor and technology agnostic open source home automation software";
      homepage = "https://www.openhab.org";
      license = licenses.epl10;
      maintainers = with maintainers; [ peterhoeg ];
    };
  };

  openhab = {
    version = "2.5.9";
    sha256 = "sha256-YQxsMW4lOY2O82Aj1PySPkZ8YMLnwQmBjRybCvr7LB4=";
  };

  openhab-v1-addons = {
    pname = "openhab-addons-legacy";
    sha256 = "sha256-XH7fLsn2oANb+ppYVSetPfQRsEoEAW/EF1CuQSlmLDY=";
    inherit (openhab) version;
  };

  openhab-v2-addons = {
    pname = "openhab-addons";
    sha256 = "sha256-XiJqhQ7gPQRHrQ4ozVSs7ssOTaLKYy8n2gQZjeSurjQ=";
    inherit (openhab) version;
  };

  openhab-milestone = {
    version = "2.5.2";
    sha256 = "1m269ibz7ic2y7mhn67x17s6jcnhj474xrxlamm7qbgi1c5k0p4j";
  };

  openhab-milestone-v1-addons = {
    pname = "openhab-addons-legacy";
    sha256 = "0vywzm9iq5d7rsjpp63jc2fin52f2g3jmmibb3rxg039hr8fi0a6";
    inherit (openhab-milestone) version;
  };

  openhab-milestone-v2-addons = {
    pname = "openhab-addons";
    sha256 = "1pg2g6y18ivjm370rdkn2i7jhr3wig68pqaaqigp1c3nk1lq59pd";
    inherit (openhab-milestone) version;
  };
in
{
  openhab = generic openhab;
  openhab-v1-addons = addon openhab-v1-addons;
  openhab-v2-addons = addon openhab-v2-addons;

  openhab-milestone = openhab;
  openhab-milestone-v1-addons = openhab-v1-addons;
  openhab-milestone-v2-addons = openhab-v2-addons;

  # openhab-milestone = generic openhab-milestone;
  # openhab-milestone-v1-addons = addon openhab-milestone-v1-addons;
  # openhab-milestone-v2-addons = addon openhab-milestone-v2-addons;
}
