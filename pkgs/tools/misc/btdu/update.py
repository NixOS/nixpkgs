#!/usr/bin/env nix-shell
#!nix-shell -i python -p python39Packages.requests

import requests
import subprocess

pkgbuild = requests.get('https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=btdu').text

def grabDepVersions(depDict, pkgbuild=pkgbuild):
    for line in pkgbuild.split('\n'):
        if depDict["string"] in line:
            start = len(depDict["string"]) + 1
            depDict["version"] = line[start:]
            break

def grabDepHashes(key,pkgbuild=pkgbuild):
    start = pkgbuild.find(key) + len(key)
    end = start+64
    hashes = []
    for i in range(5):
        hashes.append(pkgbuild[start:end])
        start     = pkgbuild.find("'",end+1) + 1
        end       = start+64
    return hashes

def findLine(key,derivation):
    count = 0
    lines = []
    for line in derivation:
        if key in line:
            lines.append(count)
        count += 1
    return lines

def updateVersions(btdu,ae,btrfs,ncurses,containers,derivation):
    key = "let"
    line = findLine(key,derivation)[0] + 1
    derivation[line+0] = f'    _d_ae_ver              = "{ae["version"]}";\n'
    derivation[line+1] = f'    _d_btrfs_ver           = "{btrfs["version"]}";\n'
    derivation[line+2] = f'    _d_ncurses_ver         = "{ncurses["version"]}";\n'
    derivation[line+3] = f'    _d_emsi_containers_ver = "{containers["version"]}";\n'

    key = "version = "
    line = findLine(key,derivation)[0]
    derivation[line] = f'    version = "{btdu["version"]}";\n'

    return derivation

def updateHashes(btdu,ae,btrfs,ncurses,containers,derivation):
    key = "sha256 = "
    hashLines = findLine(key,derivation)
    for i in range(len(hashes)):
        derivation[hashLines[i]] = f'        sha256 = "{hashes[i]}";\n'

    return derivation

if __name__ == "__main__":

    btdu       = {"string": "pkgver"}
    ae         = {"string": "_d_ae_ver"}
    btrfs      = {"string": "_d_btrfs_ver"}
    ncurses    = {"string": "_d_ncurses_ver"}
    containers = {"string": "_d_emsi_containers_ver"}

    grabDepVersions(btdu)
    grabDepVersions(ae)
    grabDepVersions(btrfs)
    grabDepVersions(ncurses)
    grabDepVersions(containers)

    hashes = grabDepHashes("sha256sums=('")

    nixpkgs = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip('\n')
    btduFolder = "/pkgs/tools/misc/btdu/"
    with open(nixpkgs + btduFolder + "default.nix", 'r') as arq:
        derivation = arq.readlines()

    derivation = updateVersions(btdu,ae,btrfs,ncurses,containers,derivation)
    derivation = updateHashes(btdu,ae,btrfs,ncurses,containers,derivation)

    with open(nixpkgs + btduFolder + "default.nix", 'w') as arq:
        arq.writelines(derivation)
