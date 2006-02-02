source $stdenv/setup

buildPhase=myBuildPhase
myBuildPhase() {
    true
}

installPhase=myInstallPhase
myInstallPhase() {
    python setup.py install --prefix=$out || fail
}

genericBuild
