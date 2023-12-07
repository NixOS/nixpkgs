#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.aiohttp nodejs nix-prefetch-git prefetch-npm-deps

from __future__ import annotations

import argparse
import ast
import asyncio
import json
import re
import subprocess
from base64 import b64encode
from binascii import unhexlify
from contextlib import AsyncExitStack, suppress
from enum import ReprEnum
from hashlib import sha256
from pathlib import Path
from typing import Any, Iterator, Literal, TypedDict, cast

from aiohttp import ClientSession

METADATA = Path(__file__).parent / "metadata.json"

GUMJS_BINDINGS = Path(__file__).parent / "frida-gumjs-bindings"


class System(tuple[str, str], ReprEnum):
    AARCH64_LINUX = ("aarch64-linux", "linux-arm64")
    X86_64_LINUX = ("x86_64-linux", "linux-x86_64")

    @property
    def nix(self) -> str:
        return self[0]

    @property
    def frida(self) -> str:
        return self[1]


class Metadata(TypedDict, total=False):
    version: str
    repo: str
    tools: Tools
    barebone: str
    compiler: str
    deps: Deps


class Tools(TypedDict, total=False):
    version: str
    hash: str


class Deps(TypedDict, total=False):
    version: str
    bundles: dict[str, Bundle]


class Bundle(TypedDict, total=False):
    sdk: str
    toolchain: str


async def get_latest_version(session: ClientSession) -> str:
    async with session.get(
        "https://api.github.com/repos/frida/frida/releases/latest"
    ) as resp:
        resp.raise_for_status()
        return cast(str, (await resp.json())["tag_name"])


async def _execute(*args: str | Path, cwd: str | Path | None = None) -> str:
    return await asyncio.get_event_loop().run_in_executor(
        None,
        lambda: subprocess.check_output(args, cwd=cwd, text=True).strip(),
    )


async def _nix_prefetch_git(url: str, rev: str) -> dict[str, Any]:
    args = (
        "nix-prefetch-git",
        url,
        rev,
        "--fetch-submodules",
    )
    return cast(dict[str, Any], json.loads(await _execute(*args)))


async def _prefetch_npm_deps(package_lock: Path) -> str:
    return await _execute("prefetch-npm-deps", package_lock)


async def _download_url(session: ClientSession, url: str) -> str:
    async with session.get(url) as resp:
        resp.raise_for_status()
        hash = sha256(await resp.read())
        return f"sha256-{b64encode(hash.digest()).decode()}"


async def _download_bundle(
    session: ClientSession,
    bundle: Bundle,
    version: str,
    system: System,
) -> None:
    async def _download(name: Literal["sdk"] | Literal["toolchain"]) -> str:
        url = f"https://build.frida.re/deps/{version}/{name}-{system.frida}.tar.bz2"
        return await _download_url(session, url)

    async with asyncio.TaskGroup() as task_group:
        sdk = task_group.create_task(_download("sdk"))
        toolchain = task_group.create_task(_download("toolchain"))

    bundle["sdk"] = await sdk
    bundle["toolchain"] = await toolchain


async def _update_gumjs_bindings(gumjs_bindings_src: Path) -> None:
    def _map_name_version(item: tuple[str, str]) -> str:
        (name, version) = item
        return f"{name}@{version}"

    relaxed_deps: dict[str, str] = {}
    exact_deps: dict[str, str] = {}

    generate_runtime_src = gumjs_bindings_src / "generate-runtime.py"
    module = ast.parse(generate_runtime_src.read_text())
    for node in ast.walk(module):
        if (
            isinstance(node, ast.Assign)
            and len(node.targets) == 1
            and isinstance(node.targets[0], ast.Name)
        ):
            match node.targets[0].id:
                case "RELAXED_DEPS":
                    relaxed_deps.update(eval(ast.unparse(node.value)))
                case "EXACT_DEPS":
                    exact_deps.update(eval(ast.unparse(node.value)))
                case _:
                    pass

    await _execute(
        "npm",
        "install",
        *map(_map_name_version, relaxed_deps.items()),
        cwd=GUMJS_BINDINGS,
    )
    await _execute(
        "npm",
        "install",
        "-E",
        *map(_map_name_version, exact_deps.items()),
        cwd=GUMJS_BINDINGS,
    )

    hash = await _prefetch_npm_deps(GUMJS_BINDINGS / "package-lock.json")

    default_nix = GUMJS_BINDINGS / "default.nix"
    default_nix.write_text(
        re.sub(
            r'hash = "([^"]*)"',
            f'hash = "{hash}"',
            default_nix.read_text(),
        )
    )


class PyPIProject(TypedDict):
    name: str
    files: list[PyPIFile]
    versions: list[str]


class PyPIFile(TypedDict):
    filename: str
    url: str
    hashes: dict[str, str]


async def get_pypi_project(session: ClientSession, name: str) -> PyPIProject:
    async with session.get(
        f"https://pypi.org/simple/{name}/",
        headers={"Accept": "application/vnd.pypi.simple.v1+json"},
    ) as resp:
        resp.raise_for_status()
        return cast(PyPIProject, await resp.json())


def pypi_files_for(project: PyPIProject, version: str) -> Iterator[PyPIFile]:
    prefix = f'{project["name"]}-{version}'
    for file in project["files"]:
        filename = file["filename"]
        if not filename.startswith(prefix):
            continue
        suffix = filename[len(prefix) :]
        if suffix == "" or suffix.startswith(("-", ".")):
            yield file


def pypi_sdist_for(project: PyPIProject, version: str) -> Iterator[PyPIFile]:
    for file in pypi_files_for(project, version):
        if file["filename"].endswith((".tar.gz", ".zip")):
            yield file


def _py_sdist_hash(project: PyPIProject, version: str) -> str:
    sha256 = ""
    for file in pypi_sdist_for(project, version):
        sha256 = file["hashes"].get("sha256", sha256)
    assert sha256, "no sdist with sha256 found"
    return f"sha256-{b64encode(unhexlify(sha256)).decode()}"


async def main(metadata: Metadata, version: str | None) -> Metadata:
    async with AsyncExitStack() as exit_stack:
        session = await exit_stack.enter_async_context(ClientSession())

        if version is None:
            version = await get_latest_version(session)

        if metadata.get("version", None) == version:
            return metadata

        metadata = Metadata(version=version)

        repo = await _nix_prefetch_git("https://github.com/frida/frida", version)
        repo_path = Path(repo["path"])

        metadata["repo"] = repo["hash"]

        tools_setup = repo_path / "frida-tools" / "setup.py"
        tools_version_match = re.search(r'version="([^"]*)"', tools_setup.read_text())
        assert tools_version_match, "failed to find version in setup.py"
        tools_version = tools_version_match.group(1)

        frida_tools = await get_pypi_project(session, "frida-tools")
        metadata["tools"] = Tools(
            version=tools_version,
            hash=_py_sdist_hash(frida_tools, tools_version),
        )

        frida_core_src = repo_path / "frida-core" / "src"
        async with asyncio.TaskGroup() as task_group:
            barebone = task_group.create_task(
                _prefetch_npm_deps(frida_core_src / "barebone" / "package-lock.json")
            )
            compiler = task_group.create_task(
                _prefetch_npm_deps(frida_core_src / "compiler" / "package-lock.json")
            )
        metadata["barebone"] = await barebone
        metadata["compiler"] = await compiler

        await _update_gumjs_bindings(repo_path / "frida-gum" / "bindings" / "gumjs")

        deps_mk = repo_path / "releng" / "deps.mk"
        deps_version_match = re.search("frida_deps_version = (.*)", deps_mk.read_text())
        assert deps_version_match, "failed to find frida_deps_version in deps.mk"
        deps_version = deps_version_match.group(1)

        bundles: dict[str, Bundle] = {}
        async with asyncio.TaskGroup() as task_group:
            for system in System.__members__.values():
                bundle = bundles.setdefault(system.nix, {})
                task_group.create_task(
                    _download_bundle(session, bundle, deps_version, system)
                )

        metadata["deps"] = Deps(
            version=deps_version,
            bundles=bundles,
        )

    return metadata


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--version",
        type=str,
    )
    args = parser.parse_args()

    metadata = Metadata()
    with suppress(FileNotFoundError):
        metadata.update(json.loads(METADATA.read_text()))
    try:
        metadata = asyncio.run(main(metadata, args.version))
    finally:
        METADATA.write_text(json.dumps(metadata, indent=2) + "\n")
