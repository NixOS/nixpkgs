{ fetchurl, unzip, buildPythonPackage, twisted, foolscap, nevow
, simplejson, zfec, pycryptopp, pysqlite, nettools }:

buildPythonPackage (rec {
  name = "tahoe-1.4.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://allmydata.org/source/tahoe/releases/allmydata-${name}.zip";
    sha256 = "1q1fc3cixjqk0agbyiqs4zqdyqsp73nxx0f168djx7yp2q1p8nsm";
  };

  patchPhase = ''
    echo "forcing Tahoe to use \`setuptools' 0.6c9 rather than an unreleased version"
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

  meta = {
    description = "Tahoe, a decentralized, fault-tolerant, distributed storage system";

    longDescription = ''
      Tahoe is a secure, decentralized, fault-tolerant filesystem.
      This filesystem is encrypted and spread over multiple peers in
      such a way that it remains available even when some of the peers
      are unavailable, malfunctioning, or malicious.
    '';

    homepage = http://allmydata.org/;

    license = "GPLv2+";
  };
})
