{
  stdenv,
  lib,
  python3,
  kernel,
  makeWrapper,
  writeText,
  gawk,
  iproute2,
}:

let
  libexec = "libexec/hypervkvpd";

  fcopy_name =
    if lib.versionOlder kernel.version "6.10" then
      "fcopy"
    else
      # The fcopy program is explicitly left out in the Makefile on aarch64
      (if stdenv.hostPlatform.isAarch64 then null else "fcopy_uio");

  daemons = stdenv.mkDerivation {
    pname = "hyperv-daemons-bin";
    inherit (kernel) src version;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ python3 ];

    postPatch = ''
      cd tools/hv
      substituteInPlace hv_kvp_daemon.c \
        --replace /usr/libexec/hypervkvpd/ $out/${libexec}/
    '';

    makeFlags = [
      "ARCH=${stdenv.hostPlatform.parsed.cpu.name}"
      "DESTDIR=$(out)"
      "sbindir=/bin"
      "libexecdir=/libexec"
    ];

    postFixup = ''
      wrapProgram $out/bin/hv_kvp_daemon \
        --prefix PATH : $out/bin:${
          lib.makeBinPath [
            gawk
            iproute2
          ]
        }
    '';
  };

  service =
    bin: title: check:
    writeText "hv-${bin}.service" ''
      [Unit]
      Description=Hyper-V ${title} daemon
      ConditionVirtualization=microsoft
      ${lib.optionalString (check != "") ''
        ConditionPathExists=/dev/vmbus/${check}
      ''}
      [Service]
      ExecStart=@out@/hv_${bin}_daemon -n
      Restart=on-failure
      PrivateTmp=true
      Slice=hyperv.slice

      [Install]
      WantedBy=hyperv-daemons.target
    '';

in
stdenv.mkDerivation {
  pname = "hyperv-daemons";
  inherit (kernel) version;

  # we just stick the bins into out as well as it requires "out"
  outputs = [
    "bin"
    "lib"
    "out"
  ];

  buildInputs = [ daemons ];
  passthru = {
    inherit daemons;
  };

  buildCommand = ''
    system=$lib/lib/systemd/system

    ${lib.optionalString (fcopy_name != null) ''
      install -Dm444 ${
        service fcopy_name "file copy (FCOPY)"
          "/sys/bus/vmbus/devices/eb765408-105f-49b6-b4aa-c123b64d17d4/uio"
      } $system/hv-fcopy.service
    ''}
    install -Dm444 ${service "kvp" "key-value pair (KVP)" "hv_kvp"} $system/hv-kvp.service
    install -Dm444 ${service "vss" "volume shadow copy (VSS)" "hv_vss"} $system/hv-vss.service

    cat > $system/hyperv-daemons.target <<EOF
    [Unit]
    Description=Hyper-V Daemons
    Wants=hv-kvp.service hv-vss.service
    ${lib.optionalString (fcopy_name != null) ''
      Wants=hv-fcopy.service
    ''}
    EOF

    for f in $lib/lib/systemd/system/*.service ; do
      substituteInPlace $f --replace @out@ ${daemons}/bin
    done

    # we need to do both $out and $bin as $out is required
    for d in $out/bin $bin/bin ; do
      # make user binaries available
      mkdir -p $d
      ln -s ${daemons}/bin/lsvmbus $d/lsvmbus
    done
  '';

  meta = with lib; {
    description = "Integration Services for running NixOS under HyperV";
    mainProgram = "lsvmbus";
    longDescription = ''
      This packages contains the daemons that are used by the Hyper-V hypervisor
      on the host.

      Microsoft calls their guest agents "Integration Services" which is why
      we use that name here.
    '';
    homepage = "https://kernel.org";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = kernel.meta.platforms;
  };
}
