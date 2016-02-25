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

{stdenv, pkgs, config, fetchurl, ... }:

stdenv.mkDerivation rec {
    name = "kippo-${version}";
    version = "0.8";
    src = fetchurl {
      url = "https://kippo.googlecode.com/files/kippo-${version}.tar.gz";
      sha1 = "f57a5cf88171cb005afe44a4b33cb16f825c33d6";
    };
    buildInputs = with pkgs.pythonPackages; [ pycrypto pyasn1 twisted_11 ];
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

    meta = with stdenv.lib; {
      homepage = https://code.google.com/p/kippo;
      description = "SSH Honeypot";
      longDescription = ''
        Default port is 2222. Recommend using something like this for port redirection to default SSH port:
        networking.firewall.extraCommands = '''
        iptables -t nat -A PREROUTING -i IN_IFACE -p tcp --dport 22 -j REDIRECT --to-port 2222''' '';
      license = licenses.bsd3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ tomberek ];
    };
}
