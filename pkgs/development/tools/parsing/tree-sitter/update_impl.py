from urllib.parse import quote
import json
import subprocess as sub
import os
import sys
from typing import Iterator, Any, Literal, TypedDict, Optional
from tempfile import NamedTemporaryFile

debug: bool = True if os.environ.get("DEBUG", False) else False
Bin = str
args: dict[str, Any] = json.loads(os.environ["ARGS"])
bins: dict[str, Bin] = args["binaries"]

mode: str = sys.argv[1]
jsonArg: dict = json.loads(sys.argv[2])

Args = Iterator[str]


def log(msg: str) -> None:
    print(msg, file=sys.stderr)


def atomically_write(file_path: str, content: bytes) -> None:
    """atomically write the content into `file_path`"""
    with NamedTemporaryFile(
        # write to the parent dir, so that it’s guaranteed to be on the same filesystem
        dir=os.path.dirname(file_path),
        delete=False
    ) as tmp:
        try:
            tmp.write(content)
            os.rename(
                src=tmp.name,
                dst=file_path
            )
        except Exception:
            os.unlink(tmp.name)


def curl_github_args(token: str | None, url: str) -> Args:
    """Query the github API via curl"""
    yield bins["curl"]
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
    yield bins["nix-prefetch-git"]
    if not debug:
        yield "--quiet"
    yield "--no-deepClone"
    yield "--url"
    yield url
    yield "--rev"
    yield version_rev


def run_cmd(args: Args) -> bytes:
    all = list(args)
    if debug:
        log(str(all))
    return sub.check_output(all)


Dir = str


def fetchRepo() -> None:
    """fetch the given repo and write its nix-prefetch output to the corresponding grammar json file"""
    match jsonArg:
        case {
            "orga": orga,
            "repo": repo,
            "outputDir": outputDir,
            "nixRepoAttrName": nixRepoAttrName,
        }:
            token: str | None = os.environ.get("GITHUB_TOKEN", None)
            out = run_cmd(
                curl_github_args(
                    token,
                    url=f"https://api.github.com/repos/{quote(orga)}/{quote(repo)}/releases/latest"
                )
            )
            release: str
            match curl_result(out):
                case "not found":
                    if "branch" in jsonArg:
                        branch = jsonArg.get("branch")
                        release = f"refs/heads/{branch}"
                    else:
                        # github sometimes returns an empty list even tough there are releases
                        log(f"uh-oh, latest for {orga}/{repo} is not there, using HEAD")
                        release = "HEAD"
                case {"tag_name": tag_name}:
                    release = tag_name
                case _:
                    sys.exit(f"git result for {orga}/{repo} did not have a `tag_name` field")

            log(f"Fetching latest release ({release}) of {orga}/{repo} …")
            res = run_cmd(
                nix_prefetch_git_args(
                    url=f"https://github.com/{quote(orga)}/{quote(repo)}",
                    version_rev=release
                )
            )
            atomically_write(
                file_path=os.path.join(
                    outputDir,
                    f"{nixRepoAttrName}.json"
                ),
                content=res
            )
        case _:
            sys.exit("input json must have `orga` and `repo` keys")


def fetchOrgaLatestRepos(orga: str) -> set[str]:
    """fetch the latest (100) repos from the given github organization"""
    token: str | None = os.environ.get("GITHUB_TOKEN", None)
    out = run_cmd(
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
            return set(res)
        case _:
            sys.exit("github result was not a list of repos, but {other}")


def checkTreeSitterRepos(latest_github_repos: set[str]) -> None:
    """Make sure we know about all tree sitter repos on the tree sitter orga."""
    known: set[str] = set(args["knownTreeSitterOrgGrammarRepos"])
    ignored: set[str] = set(args["ignoredTreeSitterOrgRepos"])

    unknown = latest_github_repos - (known | ignored)

    if unknown:
        sys.exit(f"These repositories are neither known nor ignored:\n{unknown}")


Grammar = TypedDict(
    "Grammar",
    {
        "nixRepoAttrName": str,
        "orga": str,
        "repo": str,
        "branch": Optional[str]
    }
)


def printAllGrammarsNixFile() -> None:
    """Print a .nix file that imports all grammars."""
    allGrammars: list[dict[str, Grammar]] = jsonArg["allGrammars"]
    outputDir: Dir = jsonArg["outputDir"]

    def file() -> Iterator[str]:
        yield "{ lib }:"
        yield "{"
        for grammar in allGrammars:
            n = grammar["nixRepoAttrName"]
            yield f"  {n} = lib.importJSON ./{n}.json;"
        yield "}"
        yield ""

    atomically_write(
        file_path=os.path.join(
            outputDir,
            "default.nix"
        ),
        content="\n".join(file()).encode()
    )


def fetchAndCheckTreeSitterRepos() -> None:
    log("fetching list of grammars")
    latest_repos = fetchOrgaLatestRepos(orga="tree-sitter")
    log("checking the tree-sitter repo list against the grammars we know")
    checkTreeSitterRepos(latest_repos)


match mode:
    case "fetch-repo":
        fetchRepo()
    case "fetch-and-check-tree-sitter-repos":
        fetchAndCheckTreeSitterRepos()
    case "print-all-grammars-nix-file":
        printAllGrammarsNixFile()
    case _:
        sys.exit(f"mode {mode} unknown")
