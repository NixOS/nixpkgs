# This is the installation portion of kippo.
# This is somewhat jumbled together. There is no "easy_install" for kippo,
# and there isn't a way to regenerate the twistd plugin cache.
#
# Use the services.kippo options to properly configure if on NixOS.
# On other platforms there is a problem with hardcoded paths.
# Your best bet is to change kippo source to customise
# or manually copy the proper filesystems.
# At a minimum the following are required in  /var/lib/kippo:
#     honeyfs/
#     fs.pickle
#     data/
#     txtcmds/
#
# There is also benefit in preparing /var/log/kippo
#     tty/
#     dl/
#
# Most of these files need read/write permissions.
#
# Read only files: kippo.tac and kippo.cfg
#
# Execution may look like this:
# twistd -y kippo.tac --syslog --pidfile=kippo.pid
#
# Use this package at your own risk.

{stdenv, fetchurl, pythonPackages }:

let

  twisted_13 = pythonPackages.buildPythonPackage rec {
    # NOTE: When updating please check if new versions still cause issues
    # to packages like carbon (http://stackoverflow.com/questions/19894708/cant-start-carbon-12-04-python-error-importerror-cannot-import-name-daem)
    disabled = pythonPackages.isPy3k;

    name = "Twisted-13.2.0";
    src = fetchurl {
      url = "mirror://pypi/T/Twisted/${name}.tar.bz2";
      sha256 = "1wrcqv5lvgwk2aq83qb2s2ng2vx14hbjjk2gc30cg6h1iiipal89";
    };

    propagatedBuildInputs = with pythonPackages; [ zope_interface ];

    # Generate Twisted's plug-in cache.  Twited users must do it as well.  See
    # http://twistedmatrix.com/documents/current/core/howto/plugin.html#auto3
    # and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=477103 for
    # details.
    postInstall = "$out/bin/twistd --help > /dev/null";

    meta = with stdenv.lib; {
      homepage = https://twistedmatrix.com/;
      description = "Twisted, an event-driven networking engine written in Python";
      longDescription = ''
        Twisted is an event-driven networking engine written in Python
        and licensed under the MIT license.
      '';
      license = licenses.mit;
    };
  };

in stdenv.mkDerivation rec {
    name = "kippo-${version}";
    version = "0.8";
    src = fetchurl {
      url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/kippo/${name}.tar.gz";
      sha256 = "0rd2mk36d02qd24z8s4xyy64fy54rzpar4379iq4dcjwg7l7f63d";
    };
    buildInputs = with pythonPackages; [ pycrypto pyasn1 twisted_13 ];
    installPhase = ''
        substituteInPlace ./kippo.tac --replace "kippo.cfg" "$out/src/kippo.cfg"
        substituteInPlace ./kippo.cfg --replace "log_path = log" "log_path = /var/log/kippo" \
            --replace "download_path = dl" "download_path = /var/log/kippo/dl" \
            --replace "contents_path = honeyfs" "filesystem_file = /var/lib/kippo/honeyfs" \
            --replace "filesystem_file = fs.pickle" "filesystem_file = /var/lib/kippo/fs.pickle" \
            --replace "data_path = data" "data_path = /var/lib/kippo/data" \
            --replace "txtcmds_path = txtcmds" "txtcmds_path = /var/lib/kippo/txtcmds" \
            --replace "public_key = public.key" "public_key = /var/lib/kippo/keys/public.key" \
            --replace "private_key = private.key" "private_key = /var/lib/kippo/keys/private.key"
        mkdir -p $out/bin
        mkdir -p $out/src
        mv ./* $out/src
        mv $out/src/utils/* $out/bin
        '';

    passthru.twisted = twisted_13;

    meta = with stdenv.lib; {
      homepage = https://github.com/desaster/kippo;
      description = "SSH Honeypot";
      longDescription = ''
        Default port is 2222. Recommend using something like this for port redirection to default SSH port:
        networking.firewall.extraCommands = '''
        iptables -t nat -A PREROUTING -i IN_IFACE -p tcp --dport 22 -j REDIRECT --to-port 2222''' '';
      license = licenses.bsd3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ tomberek ];
      broken = true; # 2018-09-12, failed on hydra since 2017-12-11
    };
}
