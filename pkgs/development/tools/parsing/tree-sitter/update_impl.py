from urllib.parse import quote
import json
import subprocess as sub
import os
import sys

debug = True if os.environ.get("DEBUG", False) else False

mode = sys.argv[1]
jsonArg = json.loads(sys.argv[2])


def curl_github_args(token, url):
    """Query the github API via curl"""
    yield "curl"
    if not debug:
        yield "--silent"
    if token:
        yield "-H"
        yield f"Authorization: token {token}"
    yield url


def curl_result(orga, repo, output):
    """Parse the curl result of the github API"""
    res = json.loads(output)
    message = res.get("message", "")
    if "rate limit" in message:
        sys.exit("Rate limited by the Github API")
    if "Not Found" in message:
        # repository not there or no releases; if the repo is missing,
        # we’ll notice when we try to clone it
        return {}
    return res


def nix_prefetch_args(url, version_rev):
    """Prefetch a git repository"""
    yield "nix-prefetch-git"
    if not debug:
        yield "--quiet"
    yield "--no-deepClone"
    yield "--url"
    yield url
    yield "--rev"
    yield version_rev


def fetchRepo():
    """fetch the given repo and print its nix-prefetch output to stdout"""
    match jsonArg:
        case {"orga": orga, "repo": repo}:
            token = os.environ.get("GITHUB_TOKEN", None)
            curl_cmd = list(curl_github_args(
                token,
                url=f"https://api.github.com/repos/{quote(orga)}/{quote(repo)}/releases/latest"
            ))
            if debug:
                print(curl_cmd, file=sys.stderr)
            out = sub.check_output(curl_cmd)
            release = curl_result(orga, repo, out).get("tag_name", None)

            # github sometimes returns an empty list even tough there are releases
            if not release:
                print(f"uh-oh, latest for {orga}/{repo} is not there, using HEAD", file=sys.stderr)
                release = "HEAD"

            print(f"Fetching latest release ({release}) of {orga}/{repo} …", file=sys.stderr)
            sub.check_call(
                list(nix_prefetch_args(
                    url=f"https://github.com/{quote(orga)}/{quote(repo)}",
                    version_rev=release
                ))
            )
        case _:
            sys.exit("input json must have `orga` and `repo` keys")


match mode:
    case "fetch-repo":
        fetchRepo()
    case _:
        sys.exit(f"mode {mode} unknown")
