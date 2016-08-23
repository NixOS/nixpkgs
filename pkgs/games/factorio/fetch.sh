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
 -b cookies \
 -c cookies \
 $curlOpts \
 $NIX_CURL_FLAGS"

# We don't want the password to be on any program's argv, as it may be
# visible in /proc. Writing it to file with echo should be safe, since
# it's a shell builtin.
echo -n "$password" > password
# Might as well hide the username as well.
echo -n "$username" > username

# Get a CSRF token.
csrf=$($curl $loginUrl | xidel - -e '//input[@id="csrf_token"]/@value')

# Log in. We don't especially care about the result, but let's check if login failed.
$curl --data-urlencode csrf_token="$csrf" \
      --data-urlencode username_or_email@username \
      --data-urlencode password@password \
      -d action=Login \
      $loginUrl -D headers > /dev/null

if grep -q 'Location: https://' headers; then
    # Now download. We need --insecure for this, but the sha256 should cover us.
    $curl --insecure --location $url > $out
    set +x
else
    set +x
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
