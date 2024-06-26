#!/usr/bin/env bash

set -euo pipefail

function usage() {
    {
        echo "${0} - query Azure CLI extension index"
        echo
        echo "The Azure CLI extension index contains all versions of all extensions. This"
        echo "script queries the index for the latest version of an extensions that is"
        echo "compatible with the specified version of the Azure CLI. Data for that extension"
        echo "is filtered for fields relevant to package the extension in Nix."
        echo
        echo "Usage:"
        echo "  --cli-version=<version>      version of azure-cli (required)"
        echo "  --extension=<name>           name of extension to query"
        echo "  --file=<path>                path to extension index file"
        echo "  --download                   download extension index file"
        echo "  --nix                        output Nix expression"
        echo "  --requirements=<true/false>  filter for extensions with/without requirements"
    } >&2
}

for arg in "$@"; do
    case "$arg" in
        --cli-version=*)
            cliVer="${arg#*=}"
            shift
            ;;
        --extension=*)
            extName="${arg#*=}"
            shift
            ;;
        --file=*)
            extensionFile="${arg#*=}"
            shift
            ;;
        --download)
            download=true
            shift
            ;;
        --nix)
            nix=true
            shift
            ;;
        --requirements=*)
            requirements="${arg#*=}"
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg" >&2
            exit 1
            ;;
    esac
done

if [[ -z "${cliVer:-}" ]]; then
    echo "Missing --cli-version argument" >&2
    exit 1
fi
if [[ -z "${extensionFile:-}" && -z "${download:-}" ]]; then
    echo "Either --file or --download must be specified" >&2
    exit 1
fi
if [[ -n "${extName:-}" && -n "${requirements:-}" ]]; then
    echo "--requirements can only be used when listing all extensions" >&2
    exit 1
fi

if [[ "${download:-}" == true ]]; then
    extensionFile="$(mktemp)"
    echo "Downloading extensions index to ${extensionFile}" >&2
    curl -fsSL "https://azcliextensionsync.blob.core.windows.net/index1/index.json" > "${extensionFile}"
fi

# shellcheck disable=SC2016
jqProgram='
    def opt(f):
        . as $in | try f catch $in
        ;

    def version_to_array:
        sub("\\+.*$"; "")
        | capture("^(?<v>[^a-z-]+)(?:(?<p>.*))?") | [.v, .p // empty]
        | map(split(".")
        | map(opt(tonumber)))
        | flatten
        ;

    def version_le($contstraint):
        version_to_array as $v
        | $contstraint | version_to_array as $c
        | $v[0] < $c[0] or
          ($v[0] == $c[0] and $v[1] < $c[1]) or
          ($v[0] == $c[0] and $v[1] == $c[1] and $v[2] < $c[2]) or
          ($v[0] == $c[0] and $v[1] == $c[1] and $v[2] == $c[2] and $v[3] <= $c[3])
        ;

    def max_constrained_version($constraint):
        [
            .[] | select(.metadata."azext.minCliCoreVersion" // "0.0.0" | version_le($cliVer))
        ]
        | sort_by(.metadata.version | version_to_array)
        | last
        ;

    def translate_struct:
        {
            pname : .metadata.name,
            description: .metadata.summary,
            version: .metadata.version,
            url: .downloadUrl,
            sha256: .sha256Digest,
            license: .metadata.license,
            requires: .metadata.run_requires.[0].requires
        }
        ;

    def to_nix:
        [.].[] as $in
        | .version as $version
        | .description as $description
        | .url | sub($version;"${version}") as $url
        | $description |rtrimstr(".") as $description
        | $in.pname + " = mkAzExtension rec {\n" +
        "  pname = \"" + $in.pname + "\";\n" +
        "  version = \"" + $in.version + "\";\n" +
        "  url = \"" + $url + "\";\n" +
        "  sha256 = \"" + $in.sha256 + "\";\n" +
        "  description = \"" + $description + "\";\n" +
        "};"
        ;

    def main:
        .extensions
        | map(max_constrained_version($cliVer))
        | .[]
        | translate_struct
        | if $extName  != "" then
            select(.pname == $extName)
        elif $requirements == "false" then
            select(.requires == null)
        elif $requirements == "true" then
            select(.requires != null)
        end
        | if $nix == "true" then
            to_nix
        end
        ;

    main
'

jq -r \
    --arg cliVer "${cliVer}" \
    --arg extName "${extName:-}" \
    --arg nix "${nix:-}" \
    --arg requirements "${requirements:-}" \
    "$jqProgram" "${extensionFile}"
