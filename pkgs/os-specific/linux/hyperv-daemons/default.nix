{ stdenv, lib, python2, python3, kernel, makeWrapper, writeText
, gawk, iproute2 }:

let
  libexec = "libexec/hypervkvpd";

  daemons = stdenv.mkDerivation rec {
    pname = "hyperv-daemons-bin";
    inherit (kernel) src version;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ (if lib.versionOlder version "4.19" then python2 else python3) ];

    # as of 4.9 compilation will fail due to -Werror=format-security
    hardeningDisable = [ "format" ];

    postPatch = ''
      cd tools/hv
      substituteInPlace hv_kvp_daemon.c \
        --replace /usr/libexec/hypervkvpd/ $out/${libexec}/
    '';

    # We don't actually need the hv_get_{dhcp,dns}_info scripts on NixOS in
    # their current incarnation but with them in place, we stop the spam of
    # errors in the log.
    installPhase = ''
      runHook preInstall

      for f in fcopy kvp vss ; do
        install -Dm755 hv_''${f}_daemon -t $out/bin
      done

      install -Dm755 lsvmbus             $out/bin/lsvmbus
      install -Dm755 hv_get_dhcp_info.sh $out/${libexec}/hv_get_dhcp_info
      install -Dm755 hv_get_dns_info.sh  $out/${libexec}/hv_get_dns_info

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/hv_kvp_daemon \
        --prefix PATH : $out/bin:${lib.makeBinPath [ gawk iproute2 ]}
    '';
  };

  service = bin: title: check:
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

in stdenv.mkDerivation {
  pname = "hyperv-daemons";
  inherit (kernel) version;

  # we just stick the bins into out as well as it requires "out"
  outputs = [ "bin" "lib" "out" ];

  buildInputs = [ daemons ];

  buildCommand = ''
    system=$lib/lib/systemd/system

    install -Dm444 ${service "fcopy" "file copy (FCOPY)"        "hv_fcopy" } $system/hv-fcopy.service
    install -Dm444 ${service "kvp"   "key-value pair (KVP)"     "hv_kvp"   } $system/hv-kvp.service
    install -Dm444 ${service "vss"   "volume shadow copy (VSS)" "hv_vss"   } $system/hv-vss.service

    cat > $system/hyperv-daemons.target <<EOF
    [Unit]
    Description=Hyper-V Daemons
    Wants=hv-fcopy.service hv-kvp.service hv-vss.service
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
