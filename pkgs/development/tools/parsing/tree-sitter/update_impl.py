from urllib.parse import quote
import json
import subprocess as sub
import os
import sys
from typing import Iterator, Any, Literal, NoReturn, TypedDict, cast
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


def critical(msg: str) -> NoReturn:
    sys.exit(f"ERROR: {msg}")


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


def curl_gitlab_args(url: str) -> Args:
    """Query the gitlab API via curl"""
    yield bins["curl"]
    if not debug:
        yield "--silent"
    # follow redirects
    yield "--location"
    yield url


def github_curl_result(output: bytes) -> Any | Literal["not found"]:
    """Parse the curl result of the github API"""
    res: Any = json.loads(output)
    match res:
        case dict(res):
            message: str = res.get("message", "")
            if "rate limit" in message:
                critical("Rate limited by the Github API")
            if "Not Found" in message:
                return "not found"
    # if the result is another type, we can pass it on
    return res


def gitlab_curl_result(output: bytes) -> Any:
    """Parse the curl result of the gitlab API"""
    res: Any = json.loads(output)
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

GithubRepo = TypedDict(
    "GithubRepo", {
        "orga": str,
        "repo": str
    }
)

GitlabRepo = TypedDict(
    "GitlabRepo", {
        "nixRepoAttrName": str,
        "projectId": str
    }
)

FetchRepoArg = TypedDict(
    "FetchRepoArg", {
        "type": str,
        "outputDir": Dir,
        "nixRepoAttrName": str
    }
)


def fetchRepo() -> None:
    """fetch the given repo and write its nix-prefetch output to the corresponding grammar json file"""
    arg = cast(FetchRepoArg, jsonArg)
    if debug:
        log(f"Fetching repo {arg}")
    match arg["type"]:
        case "github":
            res = fetchGithubRepo(cast(GithubRepo, jsonArg))
        case "gitlab":
            res = fetchGitlabRepo(cast(GitlabRepo, jsonArg))
        case other:
            critical(f'''Do not yet know how to handle the repo type "{other}"''')
    attrName = jsonArg["nixRepoAttrName"]
    atomically_write(
        file_path=os.path.join(
            arg["outputDir"],
            f"{attrName}.json"
        ),
        content=res
    )


def fetchGithubRepo(r: GithubRepo) -> bytes:
    token: str | None = os.environ.get("GITHUB_TOKEN", None)
    orga = r["orga"]
    repo = r["repo"]
    out = run_cmd(
        curl_github_args(
            token,
            url=f"https://api.github.com/repos/{quote(orga)}/{quote(repo)}/releases/latest"
        )
    )
    release: str
    match github_curl_result(out):
        case "not found":
            # github sometimes returns an empty list even tough there are releases
            log(f"uh-oh, latest for {orga}/{repo} is not there, using HEAD")
            release = "HEAD"
        case {"tag_name": tag_name}:
            release = tag_name
        case _:
            critical(f"git result for {orga}/{repo} did not have a `tag_name` field")

    log(f"Fetching latest release ({release}) of {orga}/{repo} …")
    return run_cmd(
        nix_prefetch_git_args(
            url=f"https://github.com/{quote(orga)}/{quote(repo)}",
            version_rev=release
        )
    )


def fetchGitlabRepo(r: GitlabRepo) -> bytes:
    projectId = r["projectId"]
    nixRepoAttrName = r["nixRepoAttrName"]
    out = run_cmd(
        curl_gitlab_args(
            url=f"https://gitlab.com/api/v4/projects/{quote(projectId)}/repository/tags?order_by=version&sort=desc"
        )
    )
    release: str
    projectName = f'''"{nixRepoAttrName}" (Gitlab projectId: {projectId})'''
    match gitlab_curl_result(out):
        case list([]):
            log(f"uh-oh, no release find for for {projectName}, using HEAD")
            release = "HEAD"
        case list([{"name": tag_name}, *_]):
            release = tag_name
        case _:
            critical(f"tag list for {projectName} did not have a `name` field: {out.decode()}")
    out = run_cmd(
        curl_gitlab_args(
            url=f"https://gitlab.com/api/v4/projects/{quote(projectId)}"
        )
    )
    url: str
    match gitlab_curl_result(out):
        case {"http_url_to_repo": url}:
            url = url
        case _:
            critical(f"repository result for {projectName} did not have a `http_url_to_repo` field: {out.decode()}")
    log(f"Fetching latest release ({release}) of {projectName} …")
    return run_cmd(
        nix_prefetch_git_args(
            url,
            version_rev=release
        )
    )


def fetchOrgaLatestRepos(orga: str) -> set[str]:
    """fetch the latest (100) repos from the given github organization"""
    token: str | None = os.environ.get("GITHUB_TOKEN", None)
    out = run_cmd(
        curl_github_args(
            token,
            url=f"https://api.github.com/orgs/{quote(orga)}/repos?per_page=100"
        )
    )
    match github_curl_result(out):
        case "not found":
            critical(f"github organization {orga} not found")
        case list(repos):
            res: list[str] = []
            for repo in repos:
                name = repo.get("name")
                if name:
                    res.append(name)
            return set(res)
        case other:
            critical(f"github result was not a list of repos, but {other}")


def checkTreeSitterRepos(latest_github_repos: set[str]) -> None:
    """Make sure we know about all tree sitter repos on the tree sitter orga."""
    known: set[str] = set(args["knownTreeSitterOrgGrammarRepos"])
    ignored: set[str] = set(args["ignoredTreeSitterOrgRepos"])

    unknown = latest_github_repos - (known | ignored)

    if unknown:
        critical(f"These repositories are neither known nor ignored:\n{unknown}")


NixRepoAttrName = str


def printAllGrammarsNixFile() -> None:
    """Print a .nix file that imports all grammars."""
    repoAttrNames: list[NixRepoAttrName] = jsonArg["repoAttrNames"]
    outputDir: Dir = jsonArg["outputDir"]

    def file() -> Iterator[str]:
        yield "{ lib }:"
        yield "{"
        for n in repoAttrNames:
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
        critical(f"mode {mode} unknown")
