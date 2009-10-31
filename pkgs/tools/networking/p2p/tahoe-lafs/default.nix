{ fetchurl, lib, unzip, buildPythonPackage, twisted, foolscap, nevow
, simplejson, zfec, pycryptopp, pysqlite, nettools }:

buildPythonPackage (rec {
  name = "tahoe-lafs-1.5.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://allmydata.org/source/tahoe/releases/allmydata-tahoe-1.5.0.zip";
    sha256 = "1cgwm7v49mlfsq47k8gw2bz14d6lnls0mr6dc18815pf24z4f00n";
  };

  patchPhase = ''
    echo "forcing the use of \`setuptools' 0.6c9 rather than an unreleased version"
    for i in *setup.py
    do
      sed -i "$i" -es'/0.6c12dev/0.6c9/g'
    done

    # `find_exe()' returns a list like ['.../bin/python'
    # '.../bin/twistd'], which doesn't work when `twistd' is not a
    # Python script (e.g., when it's a script produced by
    # `wrapProgram').
    sed -i "src/allmydata/scripts/startstop_node.py" \
        -es"|cmd = find_exe.find_exe('twistd')|cmd = ['${twisted}/bin/twistd']|g"

    sed -i "src/allmydata/util/iputil.py" \
        -es"|_linux_path = '/sbin/ifconfig'|_linux_path = '${nettools}/sbin/ifconfig'|g"
  '';

  buildInputs = [ unzip ];

  # The `backup' command works best with `pysqlite'.
  propagatedBuildInputs = [
    twisted foolscap nevow simplejson zfec pycryptopp pysqlite
  ];

  # FIXME: Many tests try to write to the Nix store or to $HOME, which
  # fails.  Disable tests until we have a reasonable hack to allow
  # them to run.
  doCheck = false;

  postInstall = ''
    # Install the documentation.

    # FIXME: Inkscape segfaults when run from here.  Setting $HOME to
    # something writable doesn't help; providing $FONTCONFIG_FILE doesn't
    # help either.  So we just don't run `make' under `docs/'.

    ensureDir "$out/share/doc/${name}"
    cp -rv "docs/"* "$out/share/doc/${name}"
    find "$out/share/doc/${name}" -name Makefile -exec rm -v {} \;
  '';

  meta = {
    description = "Tahoe-LAFS, a decentralized, fault-tolerant, distributed storage system";

    longDescription = ''
      Tahoe-LAFS is a secure, decentralized, fault-tolerant filesystem.
      This filesystem is encrypted and spread over multiple peers in
      such a way that it remains available even when some of the peers
      are unavailable, malfunctioning, or malicious.
    '';

    homepage = http://allmydata.org/;

    license = [ "GPLv2+" /* or */ "TGPPLv1+" ];

    maintainers = [ lib.maintainers.ludo ];
  };
})
