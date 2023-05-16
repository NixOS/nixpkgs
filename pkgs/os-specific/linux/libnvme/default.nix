{ fetchFromGitHub
, json_c
, keyutils
, lib
, meson
, ninja
, openssl
, perl
, pkg-config
, python3
, stdenv
, swig
, systemd
<<<<<<< HEAD
# ImportError: cannot import name 'mlog' from 'mesonbuild'
, withDocs ? stdenv.hostPlatform.canExecute stdenv.buildPlatform
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "libnvme";
  version = "1.4";

<<<<<<< HEAD
  outputs = [ "out" ] ++ lib.optionals withDocs [ "man" ];
=======
  outputs = [ "out" "man" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "libnvme";
    rev = "v${version}";
    sha256 = "sha256-8DlEQ4LH6UhIHr0znJGqkuCosLHqA6hkJjmiCawNE1k=";
  };

  postPatch = ''
    patchShebangs meson-vcs-tag.sh
    chmod +x doc/kernel-doc-check
    patchShebangs doc/kernel-doc doc/kernel-doc-check doc/list-man-pages.sh
  '';

  nativeBuildInputs = [
    meson
    ninja
    perl # for kernel-doc
    pkg-config
    python3.pythonForBuild
    swig
  ];

  buildInputs = [
    keyutils
    json_c
    openssl
    systemd
    python3
  ];

  mesonFlags = [
    "-Ddocs=man"
<<<<<<< HEAD
    (lib.mesonBool "docs-build" withDocs)
=======
    "-Ddocs-build=true"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  preConfigure = ''
    export KBUILD_BUILD_TIMESTAMP="$(date -u -d @$SOURCE_DATE_EPOCH)"
  '';

  doCheck = true;

  meta = with lib; {
    description = "C Library for NVM Express on Linux";
    homepage = "https://github.com/linux-nvme/libnvme";
<<<<<<< HEAD
    maintainers = [ maintainers.fogti ];
=======
    maintainers = with maintainers; [ zseri ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ lgpl21Plus ];
    platforms = platforms.linux;
  };
}
