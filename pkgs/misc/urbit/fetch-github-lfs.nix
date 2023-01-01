{ lib, stdenvNoCC, runCommandLocal, cacert, curl, jq }:

{ src
# `name` shouldn't use `baseNameOf` otherwise we'll
# get `is not allowed to refer to a store path` errors.
, name ? baseNameOf src, owner ? "urbit", repo ? "urbit"
, preferLocalBuild ? true }:
let

  # Parse the first 7 characters of the supplied `src` path for the required
  # `version` key as defined by the lfs specification:
  # https://github.com/git-lfs/git-lfs/blob/master/docs/spec.md
  #
  # If `version` exists we assume we're dealing with a lfs pointer and parse
  # the `oid` and `size` from the pointer and write these into a JSON object.
  #
  # If the first 7 characters are unrecognised we assume the path is a binary
  # file and set both `oid` and `size` to `null`.
  #
  # The `oid` and `size` are then JSON decoded into an expression to use
  # as the fixed-output derivation's `sha256 = oid`, and to form a download
  # operation payload to request the actual lfs blob's real url.
  pointer = builtins.fromJSON (builtins.readFile
    (runCommandLocal "lfs-pointer-${name}" { } ''
      oid="null"
      size="null"

      if [[ "$(head -c 7 "${src}")" != "version" ]]; then
        header "lfs ${src} is a binary blob, skipping"
      else
        header "reading lfs pointer from ${src}"

        contents=($(awk '{print $2}' "${src}"))
        oid="''${contents[1]#sha256:}"
        size="''${contents[2]}"
      fi

      cat <<EOF > "$out"
      {"oid": "$oid", "size": $size}
      EOF
    ''));

  downloadUrl =
    "https://github.com/${owner}/${repo}.git/info/lfs/objects/batch";

  # Encode `oid` and `size` into a download operation per:
  # https://github.com/git-lfs/git-lfs/blob/master/docs/api/batch.md
  #
  # This is done using toJSON to avoid bash quotation issues.
  downloadPayload = builtins.toJSON {
    operation = "download";
    objects = [ pointer ];
  };

  # Define a fixed-output derivation using the lfs pointer's `oid` as the
  # expected sha256 output hash, if `oid` is not null.
  #

  # 1. Request the actual url of the binary file from the lfs batch api.
  # 2. Download the binary file contents to `$out`.
  download = stdenvNoCC.mkDerivation {
    name = "lfs-blob-${name}";
    nativeBuildInputs = [ curl jq ];
    phases = [ "installPhase" ];
    installPhase = ''
      curl=(
          curl
          --location
          --max-redirs 20
          --retry 3
          --disable-epsv
          --cookie-jar cookies
          $NIX_CURL_FLAGS
        )

      header "reading lfs metadata from ${downloadUrl}"

      href=$("''${curl[@]}" \
        -d '${downloadPayload}' \
        -H 'Accept: application/vnd.git-lfs+json' \
        '${downloadUrl}' \
          | jq -r '.objects[0].actions.download.href')

      header "download lfs data from remote"

      # Pozor/Achtung: the href contains credential and signature information,
      # so we avoid echoing it to stdout/err.
      "''${curl[@]}" -s --output "$out" "$href"
    '';

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;

    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    outputHashAlgo = "sha256";
    outputHashMode = "flat";
    outputHash = pointer.oid;

    inherit preferLocalBuild;
  };

  # If `pointer.oid` is null then supplied the `src` must be a binary
  # blob and can be returned directly.
in if pointer.oid == null || pointer.size == null then src else download
