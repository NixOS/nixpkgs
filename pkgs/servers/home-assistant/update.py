#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=channel:nixpkgs-unstable -i python3 -p "python3.withPackages (ps: with ps; [ aiohttp packaging ])" -p git nurl nodePackages.pyright ruff isort

import asyncio
import json
import os
import re
import sys
from subprocess import check_output, run
from typing import Dict, Final, List, Optional, Union

import aiohttp
from aiohttp import ClientSession
from packaging.version import Version

ROOT: Final = check_output([
    "git",
    "rev-parse",
    "--show-toplevel",
]).decode().strip()


def run_sync(cmd: List[str]) -> None:
    print(f"$ {' '.join(cmd)}")
    process = run(cmd)

    if process.returncode != 0:
        sys.exit(1)


async def check_async(cmd: List[str]) -> str:
    print(f"$ {' '.join(cmd)}")
    process = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )
    stdout, stderr = await process.communicate()

    if process.returncode != 0:
        error = stderr.decode()
        raise RuntimeError(f"{cmd[0]} failed: {error}")

    return stdout.decode().strip()


async def run_async(cmd: List[str]):
    print(f"$ {' '.join(cmd)}")

    process = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    stdout, stderr = await process.communicate()

    print(stdout.decode())

    if process.returncode != 0:
        error = stderr.decode()
        raise RuntimeError(f"{cmd[0]} failed: {error}")


class File:
    def __init__(self, path: str):
        self.path = os.path.join(ROOT, path)

    def __enter__(self):
        with open(self.path, "r") as handle:
            self.text = handle.read()
        return self

    def get_exact_match(self, attr: str, value: str):
        matches = re.findall(
            rf'{re.escape(attr)}\s+=\s+\"?{re.escape(value)}\"?',
            self.text
        )

        n = len(matches)
        if n > 1:
            raise ValueError(f"multiple occurrences found for {attr}={value}")
        elif n == 1:
            return matches.pop()
        else:
            raise ValueError(f"no occurrence found for {attr}={value}")

    def substitute(self, attr: str, old_value: str, new_value: str) -> None:
        old_line = self.get_exact_match(attr, old_value)
        new_line = old_line.replace(old_value, new_value)
        self.text = self.text.replace(old_line, new_line)
        print(f"Substitute `{attr}` value `{old_value}` with `{new_value}`")

    def __exit__(self, exc_type, exc_val, exc_tb):
        with open(self.path, "w") as handle:
            handle.write(self.text)

class Nurl:
    @classmethod
    async def prefetch(cls, url: str, version: str, *extra_args: str) -> str:
        cmd = [
            "nurl",
            "--hash",
            url,
            version,
        ]
        cmd.extend(extra_args)
        return await check_async(cmd)


class Nix:
    base_cmd: Final = [
        "nix",
        "--show-trace",
        "--extra-experimental-features", "nix-command"
    ]

    @classmethod
    async def _run(cls, args: List[str]) -> Optional[str]:
        return await check_async(cls.base_cmd + args)

    @classmethod
    async def eval(cls, expr: str) -> Union[List, Dict, int, float, str, bool]:
        response = await cls._run([
            "eval",
            "-f", f"{ROOT}/default.nix",
            "--json",
            expr
        ])
        if response is None:
            raise RuntimeError("Nix eval expression returned no response")
        try:
            return json.loads(response)
        except (TypeError, ValueError):
            raise RuntimeError("Nix eval response could not be parsed from JSON")

    @classmethod
    async def hash_to_sri(cls, algorithm: str, value: str) -> Optional[str]:
        return await cls._run([
            "hash",
            "to-sri",
            "--type", algorithm,
            value
        ])


class HomeAssistant:
    def __init__(self, session: ClientSession):
        self._session = session

    async def get_latest_core_version(
        self,
        owner: str = "home-assistant",
        repo: str = "core"
    ) -> str:
        async with self._session.get(
            f"https://api.github.com/repos/{owner}/{repo}/releases/latest"
        ) as response:
            document = await response.json()
        try:
            return str(document.get("name"))
        except KeyError:
            raise RuntimeError("No tag name in response document")


    async def get_latest_frontend_version(
        self,
        core_version: str
    ) -> str:
        async with self._session.get(
            f"https://raw.githubusercontent.com/home-assistant/core/{core_version}/homeassistant/components/frontend/manifest.json"
        ) as response:
            document = await response.json(content_type="text/plain")

        requirements = [
            requirement
            for requirement in document.get("requirements", [])
            if requirement.startswith("home-assistant-frontend==")
        ]

        if len(requirements) > 1:
            raise RuntimeError(
                "Found more than one version specifier for the frontend package"
            )
        elif len(requirements) == 1:
            requirement = requirements.pop()
            _, version = requirement.split("==", maxsplit=1)
            return str(version)
        else:
            raise RuntimeError(
                "Found no version specifier for frontend package"
            )


    async def update_core(self, old_version: str, new_version: str) -> None:
        old_sdist_hash = str(await Nix.eval("home-assistant.src.outputHash"))
        new_sdist_hash = await Nurl.prefetch("https://pypi.org/project/homeassistant/", new_version)
        print(f"sdist: {old_sdist_hash} -> {new_sdist_hash}")

        old_git_hash = str(await Nix.eval("home-assistant.gitSrc.outputHash"))
        new_git_hash = await Nurl.prefetch("https://github.com/home-assistant/core/", new_version)
        print(f"git: {old_git_hash} -> {new_git_hash}")

        with File("pkgs/servers/home-assistant/default.nix") as file:
            file.substitute("hassVersion", old_version, new_version)
            file.substitute("hash", old_sdist_hash, new_sdist_hash)
            file.substitute("hash", old_git_hash, new_git_hash)

    async def update_frontend(self, old_version: str, new_version: str) -> None:
        old_hash = str(await Nix.eval("home-assistant.frontend.src.outputHash"))
        new_hash = await Nurl.prefetch(
            "https://pypi.org/project/home_assistant_frontend/",
            new_version,
            "-A", "format", "wheel",
            "-A", "dist", "py3",
            "-A", "python", "py3"
        )
        print(f"frontend: {old_hash} -> {new_hash}")

        with File("pkgs/servers/home-assistant/frontend.nix") as file:
            file.substitute("version", old_version, new_version)
            file.substitute("hash", old_hash, new_hash)

    async def update_components(self):
        await run_async([
            f"{ROOT}/pkgs/servers/home-assistant/parse-requirements.py"
        ])


async def main():
    headers = {}
    if token := os.environ.get("GITHUB_TOKEN", None):
        headers.update({"GITHUB_TOKEN": token})

    async with aiohttp.ClientSession(headers=headers) as client:
        hass = HomeAssistant(client)

        core_current = str(await Nix.eval("home-assistant.version"))
        core_latest = await hass.get_latest_core_version()

        if Version(core_latest) > Version(core_current):
            print(f"New Home Assistant version {core_latest} is available")
            await hass.update_core(str(core_current), str(core_latest))

            frontend_current = str(await Nix.eval("home-assistant.frontend.version"))
            frontend_latest = await hass.get_latest_frontend_version(str(core_latest))

            if Version(frontend_latest) > Version(frontend_current):
                await hass.update_frontend(str(frontend_current), str(frontend_latest))

            await hass.update_components()

        else:
            print(f"Home Assistant {core_current} is still the latest version.")

        # wait for async client sessions to close
        # https://docs.aiohttp.org/en/stable/client_advanced.html#graceful-shutdown
        await asyncio.sleep(0)

if __name__ == "__main__":
    run_sync(["pyright", __file__])
    run_sync(["ruff", "--ignore=E501", __file__])
    run_sync(["isort", __file__])
    asyncio.run(main())
