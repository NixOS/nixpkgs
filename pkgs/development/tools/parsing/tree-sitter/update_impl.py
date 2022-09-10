from urllib.parse import quote
import json
import subprocess as sub
import os
import sys
from typing import Generator, Any, Literal

debug: bool = True if os.environ.get("DEBUG", False) else False
Bin = str
bins: dict[str, Bin] = json.loads(os.environ["BINARIES"])

mode: str = sys.argv[1]
jsonArg: dict = json.loads(sys.argv[2])

Args = Generator[str, None, None]


def curl_github_args(token: str | None, url: str) -> Args:
    """Query the github API via curl"""
    if not debug:
        yield "--silent"
    # follow redirects
    yield "--location"
    if token:
        yield "-H"
        yield f"Authorization: token {token}"
    yield url


def curl_result(output: bytes) -> Any | Literal["not found"]:
    """Parse the curl result of the github API"""
    res: Any = json.loads(output)
    match res:
        case dict(res):
            message: str = res.get("message", "")
            if "rate limit" in message:
                sys.exit("Rate limited by the Github API")
            if "Not Found" in message:
                return "not found"
    # if the result is another type, we can pass it on
    return res


def nix_prefetch_git_args(url: str, version_rev: str) -> Args:
    """Prefetch a git repository"""
    if not debug:
        yield "--quiet"
    yield "--no-deepClone"
    yield "--url"
    yield url
    yield "--rev"
    yield version_rev


def run_bin(cmd: str, args: Args) -> bytes:
    bin: Bin = bins[cmd]
    all = [bin] + list(args)
    if debug:
        print(all, file=sys.stderr)
    return sub.check_output(all)


def fetchRepo() -> None:
    """fetch the given repo and print its nix-prefetch output to stdout"""
    match jsonArg:
        case {"orga": orga, "repo": repo}:
            token: str | None = os.environ.get("GITHUB_TOKEN", None)
            out = run_bin(
                "curl",
                curl_github_args(
                    token,
                    url=f"https://api.github.com/repos/{quote(orga)}/{quote(repo)}/releases/latest"
                )
            )
            release: str
            match curl_result(out):
                case "not found":
                    # github sometimes returns an empty list even tough there are releases
                    print(f"uh-oh, latest for {orga}/{repo} is not there, using HEAD", file=sys.stderr)
                    release = "HEAD"
                case {"tag_name": tag_name}:
                    release = tag_name
                case _:
                    sys.exit(f"git result for {orga}/{repo} did not have a `tag_name` field")

            print(f"Fetching latest release ({release}) of {orga}/{repo} …", file=sys.stderr)
            res = run_bin(
                "nix-prefetch-git",
                nix_prefetch_git_args(
                    url=f"https://github.com/{quote(orga)}/{quote(repo)}",
                    version_rev=release
                )
            )
            sys.stdout.buffer.write(res)
        case _:
            sys.exit("input json must have `orga` and `repo` keys")


def fetchOrgaLatestRepos() -> None:
    """fetch the latest (100) repos from the given github organization"""
    match jsonArg:
        case {"orga": orga}:
            token: str | None = os.environ.get("GITHUB_TOKEN", None)
            out = run_bin(
                "curl",
                curl_github_args(
                    token,
                    url=f"https://api.github.com/orgs/{quote(orga)}/repos?per_page=100"
                )
            )
            match curl_result(out):
                case "not found":
                    sys.exit(f"github organization {orga} not found")
                case list(repos):
                    res: list[str] = []
                    for repo in repos:
                        name = repo.get("name")
                        if name:
                            res.append(name)
                    json.dump(res, sys.stdout)
                case other:
                    sys.exit(f"github result was not a list of repos, but {other}")
        case _:
            sys.exit("input json must have `orga` key")


match mode:
    case "fetch-repo":
        fetchRepo()
    case "fetch-orga-latest-repos":
        fetchOrgaLatestRepos()
    case _:
        sys.exit(f"mode {mode} unknown")
