# This derivation confirms that the version of hpack used by stack in Nixpkgs
# is the exact same version as the upstream stack release.
#
# It is important to make sure the version of hpack used by stack in Nixpkgs
# matches with the version of hpack used by the upstream stack release.  This
# is because hpack works slightly differently based on the version, and it can
# be frustrating to use hpack in a team setting when members are using different
# versions. See for more info: https://github.com/NixOS/nixpkgs/issues/223390
#
# This test is written as a fixed-output derivation, because we need to access
# accesses the internet to download the upstream stack release.

{
  cacert,
  curl,
  lib,
  stack,
  stdenv,
}:

let
  # Find the hpack derivation that is a dependency of stack.  Throw exception
  # if hpack cannot be found.
  hpack =
    lib.findFirst (v: v.pname or "" == "hpack") (throw "could not find stack's hpack dependency")
      stack.passthru.getCabalDeps.executableHaskellDepends;

  # This is a statically linked version of stack, so it should be usable within
  # the Nixpkgs builder (at least on x86_64-linux).
  stackDownloadUrl = "https://github.com/commercialhaskell/stack/releases/download/v${stack.version}/stack-${stack.version}-linux-x86_64.tar.gz";

  # This test code has been explicitly pulled out of the derivation below so
  # that it can be hashed and added to the `name` of the derivation.  This is
  # so that this test derivation won't be cached if the body of the test is
  # modified.
  #
  # WARNING: When modifying this script, make sure you don't introduce any
  # paths to the Nix store within it.  We only want this derivation to be re-run
  # when the stack version (or the version of its hpack dependency) changes in
  # Nixpkgs.
  testScript = ''
    curl=(
      curl
      --location
      --max-redirs 20
      --retry 3
      --disable-epsv
      --cookie-jar cookies
      --user-agent "nixpkgs stack version test/1.0"
      --insecure
    )

    # Fetch the statically-linked upstream Stack binary.
    echo "Trying to download a statically linked stack binary from ${stackDownloadUrl} to ./stack.tar.gz ..."
    "''${curl[@]}" "${stackDownloadUrl}" > ./stack.tar.gz
    tar xf ./stack.tar.gz

    upstream_stack_version_output="$(./stack-${stack.version}-linux-x86_64/stack --version)"
    echo "upstream \`stack --version\` output: $upstream_stack_version_output"

    nixpkgs_stack_version_output="$(stack --version)"
    echo "nixpkgs \`stack --version\` output: $nixpkgs_stack_version_output"

    # Confirm that the upstream stack version is the same as the stack version
    # in Nixpkgs. This check isn't strictly necessary, but it is a good sanity
    # check.

    if [[ "$upstream_stack_version_output" =~ "Version "([0-9]+((\.[0-9]+)+)) ]]; then
      upstream_stack_version="''${BASH_REMATCH[1]}"

      echo "parsed upstream stack version: $upstream_stack_version"
      echo "stack version from nixpkgs: ${stack.version}"

      if [[ "${stack.version}" != "$upstream_stack_version" ]]; then
        echo "ERROR: stack version in Nixpkgs (${stack.version}) does not match the upstream version for some reason: $upstream_stack_version"
        exit 1
      fi
    else
      echo "ERROR: Upstream stack version cannot be found in --version output: $upstream_stack_version"
      exit 1
    fi

    # Confirm that the hpack version used in the upstream stack release is the
    # same as the hpack version used by the Nixpkgs stack binary.

    if [[ "$upstream_stack_version_output" =~ hpack-([0-9]+((\.[0-9]+)+)) ]]; then
      upstream_hpack_version="''${BASH_REMATCH[1]}"

      echo "parsed upstream stack's hpack version: $upstream_hpack_version"
      echo "Nixpkgs stack's hpack version: ${hpack.version}"

      if [[ "${hpack.version}" != "$upstream_hpack_version" ]]; then
        echo "ERROR: stack's hpack version in Nixpkgs (${hpack.version}) does not match the upstream stack's hpack version: $upstream_hpack_version"
        echo "The stack derivation in Nixpkgs needs to be fixed up so that it depends on hpack-$upstream_hpack_version, instead of ${hpack.name}"
        exit 1
      fi
    else
      echo "ERROR: Upstream stack's hpack version cannot be found in --version output: $upstream_hpack_version"
      exit 1
    fi

    # Output a string with a known hash.
    echo "success" > $out
  '';

  testScriptHash = builtins.hashString "sha256" testScript;
in

stdenv.mkDerivation {

  # This name is very important.
  #
  # The idea here is that want this derivation to be re-run everytime the
  # version of stack (or the version of its hpack dependency) changes in
  # Nixpkgs.  We also want to re-run this derivation whenever the test script
  # is changed.
  #
  # Nix/Hydra will re-run derivations if their name changes (even if they are a
  # FOD and they have the same hash).
  #
  # The name of this derivation contains the stack version string, the hpack
  # version string, and a hash of the test script.  So Nix will know to
  # re-run this version when (and only when) one of those values change.
  name = "upstream-stack-hpack-version-test-${stack.name}-${hpack.name}-${testScriptHash}";

  # This is the sha256 hash for the string "success", which is output upon this
  # test succeeding.
  outputHash = "sha256-gbK9TqmMjbZlVPvI12N6GmmhMPMx/rcyt1yqtMSGj9U=";
  outputHashMode = "flat";
  outputHashAlgo = "sha256";

  nativeBuildInputs = [
    curl
    stack
  ];

  impureEnvVars = lib.fetchers.proxyImpureEnvVars;

  buildCommand = ''
    # Make sure curl can access HTTPS sites, like GitHub.
    #
    # Note that we absolutely don't want the Nix store path of the cacert
    # derivation in the testScript, because we don't want to rebuild this
    # derivation when only the cacert derivation changes.
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
  ''
  + testScript;

  meta = with lib; {
    description = "Test that the stack in Nixpkgs uses the same version of Hpack as the upstream stack release";
    maintainers = with maintainers; [ cdepillabout ];

    # This derivation internally runs a statically-linked version of stack from
    # upstream.  This statically-linked version of stack is only available for
    # x86_64-linux, so this test can only be run on x86_64-linux.
    platforms = [ "x86_64-linux" ];
  };
}
