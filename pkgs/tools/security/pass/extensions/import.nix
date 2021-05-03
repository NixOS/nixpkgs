{ lib
, fetchFromGitHub
, fetchpatch
, python3Packages
, gnupg
, pass
}:

python3Packages.buildPythonApplication rec {
  pname = "pass-import";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-import";
    rev = "v${version}";
    sha256 = "sha256-nH2xAqWfMT+Brv3z9Aw6nbvYqArEZjpM28rKsRPihqA=";
  };

  patches = [
    (fetchpatch {
      name = "support-for-keepass-4.0.0.patch";
      url = "https://github.com/roddhjav/pass-import/commit/86cfb1bb13a271fefe1e70f24be18e15a83a04d8.patch";
      sha256 = "0mrlblqlmwl9gqs2id4rl4sivrcclsv6zyc6vjqi78kkqmnwzhxh";
    })
    # by default, tries to install scripts/pimport, which is a bash wrapper around "python -m pass_import ..."
    # This is a better way to do the same, and takes advantage of the existing Nix python environments
    # from https://github.com/roddhjav/pass-import/pull/138
    (fetchpatch {
      name = "pass-import-pr-138-pimport-entrypoint.patch";
      url = "https://github.com/roddhjav/pass-import/commit/ccdb6995bee6436992dd80d7b3101f0eb94c59bb.patch";
      sha256 = "sha256-CO8PyWxa4eLuTQBB+jKTImFPlPn+1yt6NBsIp+SPk94=";
    })
  ];

  propagatedBuildInputs = with python3Packages; [
    cryptography
    defusedxml
    pyaml
    pykeepass
    python_magic  # similar API to "file-magic", but already in nixpkgs.
    secretstorage
  ];

  checkInputs = [
    gnupg
    pass
    python3Packages.pytestCheckHook
  ];

  disabledTests = [
    "test_import_gnome_keyring" # requires dbus, which pytest doesn't support
  ];
  postCheck = ''
    $out/bin/pimport --list-exporters --list-importers
  '';

  meta = with lib; {
    description = "Pass extension for importing data from existing password managers";
    homepage = "https://github.com/roddhjav/pass-import";
    changelog = "https://github.com/roddhjav/pass-import/blob/v${version}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 fpletz tadfisher ];
    platforms = platforms.unix;
  };
}
