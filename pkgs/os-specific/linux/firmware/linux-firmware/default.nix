{ stdenvNoCC
, fetchzip
, findutils
, lib
, python3
, rdfind
, which
, writeShellScriptBin
}:
let
  # check-whence.py attempts to call `git ls-files`, but we don't have a .git,
  # because we've just downloaded a snapshot. We do, however, know that we're
  # in a perfectly pristine tree, so we can fake just enough of git to run it.
  gitStub = writeShellScriptBin "git" ''
    if [ "$1" == "ls-files" ]; then
      ${lib.getExe findutils} -type f -printf "%P\n"
    else
      echo "Git stub called with unexpected arguments $@" >&2
      exit 1
    fi
  '';
in stdenvNoCC.mkDerivation rec {
  pname = "linux-firmware";
  version = "20241017";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-${version}.tar.gz";
    hash = "sha256-q4StJdoLCHQThFTzhxETDYlQP/ywmb3vwCr13xtrQzc=";
  };

  postUnpack = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    gitStub
    python3
    rdfind
    which
  ];

  installTargets = [ "install" "dedup" ];
  makeFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  meta = with lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };
  passthru.updateScript = ./update.sh;
}
