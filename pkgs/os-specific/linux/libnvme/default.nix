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
# ImportError: cannot import name 'mlog' from 'mesonbuild'
, withDocs ? stdenv.hostPlatform.canExecute stdenv.buildPlatform
}:

stdenv.mkDerivation rec {
  pname = "libnvme";
  version = "1.4";

  outputs = [ "out" ] ++ lib.optionals withDocs [ "man" ];

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
    (lib.mesonBool "docs-build" withDocs)
  ];

  preConfigure = ''
    export KBUILD_BUILD_TIMESTAMP="$(date -u -d @$SOURCE_DATE_EPOCH)"
  '';

  doCheck = true;

  meta = with lib; {
    description = "C Library for NVM Express on Linux";
    homepage = "https://github.com/linux-nvme/libnvme";
    maintainers = with maintainers; [ zseri ];
    license = with licenses; [ lgpl21Plus ];
    platforms = platforms.linux;
  };
}
