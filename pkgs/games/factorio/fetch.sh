source $stdenv/setup

# Curl flags to increase reliability a bit.
#
# Can't use fetchurl, for several reasons. One is that we definitely
# don't want --insecure for the login, though we need it for the
# download as their download cert isn't in the standard linux bundle.
curl="curl \
 --max-redirs 20 \
 --retry 3 \
 --cacert $cacert/etc/ssl/certs/ca-bundle.crt \
 $curlOpts \
 $NIX_CURL_FLAGS"

# We don't want the password to be on any program's argv, as it may be
# visible in /proc. Writing it to file with echo should be safe, since
# it's a shell builtin.
echo "password=$password" > password
# Might as well hide the username as well.
echo "username-or-email=$username" > username

# Log in. We don't especially care about the result, but let's check if login failed.
$curl -c cookies -d @username -d @password $loginUrl -D headers > /dev/null

if grep -q 'Location: /' headers; then
    # Now download. We need --insecure for this, but the sha256 should cover us.
    $curl -b cookies --insecure --location $url > $out
else
    echo 'Login failed'
    echo 'Please set username and password with config.nix,'
    echo 'or /etc/nix/nixpkgs-config.nix if on NixOS.'
    echo
    echo 'Example:'
    echo '{'
    echo '  packageOverrides = pkgs: rec {'
    echo '    factorio = pkgs.factorio.override {'
    echo '      username = "<username or email address>";'
    echo '      password = "<password>";'
    echo '    };'
    echo '  };'
    echo '}'

    exit 1
fi
