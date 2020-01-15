{ stdenv, lib, python, kernel, makeWrapper, writeText }:

let
  daemons = stdenv.mkDerivation {
    pname = "hyperv-daemons-bin";
    inherit (kernel) src version;

    nativeBuildInputs = [ makeWrapper ];

    # as of 4.9 compilation will fail due to -Werror=format-security
    hardeningDisable = [ "format" ];

    preConfigure = ''
      cd tools/hv
    '';

    installPhase = ''
      runHook preInstall

      for f in fcopy kvp vss ; do
        install -Dm755 hv_''${f}_daemon -t $out/bin
      done

      install -Dm755 hv_get_dns_info.sh lsvmbus -t $out/bin

      # I don't know why this isn't being handled automatically by fixupPhase
      substituteInPlace $out/bin/lsvmbus \
        --replace '/usr/bin/env python' ${python.interpreter}

      runHook postInstall
    '';

    postFixup = ''
      # kvp needs to be able to find the script(s)
      wrapProgram $out/bin/hv_kvp_daemon --prefix PATH : $out/bin
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

  phases = [ "installPhase" ];

  buildInputs = [ daemons ];

  installPhase = ''
    system=$lib/lib/systemd/system

    mkdir -p $system

    cp ${service "fcopy" "file copy (FCOPY)" "hv_fcopy" } $system/hv-fcopy.service
    cp ${service "kvp"   "key-value pair (KVP)"     ""  } $system/hv-kvp.service
    cp ${service "vss"   "volume shadow copy (VSS)" ""  } $system/hv-vss.service

    cat > $system/hyperv-daemons.target <<EOF
    [Unit]
    Description=Hyper-V Daemons
    Wants=hv-fcopy.service hv-kvp.service hv-vss.service
    EOF

    for f in $lib/lib/systemd/system/* ; do
      substituteInPlace $f --replace @out@ ${daemons}/bin
    done

    # we need to do both $out and $bin as $out is required
    for d in $out/bin $bin/bin ; do
      # make user binaries available
      mkdir -p $d
      ln -s ${daemons}/bin/lsvmbus $d/lsvmbus
    done
  '';

  meta = with stdenv.lib; {
    description = "Integration Services for running NixOS under HyperV";
    longDescription = ''
      This packages contains the daemons that are used by the Hyper-V hypervisor
      on the host.

      Microsoft calls their guest agents "Integration Services" which is why
      we use that name here.
    '';
    homepage = https://kernel.org;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = kernel.meta.platforms;
  };
}
