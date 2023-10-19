{ lib
, fetchFromGitHub
, fetchpatch
, python3Packages
, gnupg
, pass
}:

python3Packages.buildPythonApplication rec {
  pname = "pass-import";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-import";
    rev = "v${version}";
    sha256 = "0hrpg7yiv50xmbajfy0zdilsyhbj5iv0qnlrgkfv99q1dvd5qy56";
  };

  patches = [
    (fetchpatch {
      name = "support-for-pykeepass-4.0.3.patch";
      url = "https://github.com/roddhjav/pass-import/commit/f1b167578916d971ee4f99be99ba0e86ef49015e.patch";
      hash = "sha256-u6bJbV3/QTfRaPauKSyCWNodpy6CKsreMXUZWKRbee0=";
    })
  ];

  propagatedBuildInputs = with python3Packages; [
    cryptography
    defusedxml
    pyaml
    pykeepass
    python-magic # similar API to "file-magic", but already in nixpkgs.
    secretstorage
  ];

  nativeCheckInputs = [
    gnupg
    pass
    python3Packages.pytestCheckHook
  ];

  disabledTests = [
    "test_import_gnome_keyring" # requires dbus, which pytest doesn't support
  ];

  postInstall = ''
    mkdir -p $out/lib/password-store/extensions
    cp ${src}/import.bash $out/lib/password-store/extensions/import.bash
    wrapProgram $out/lib/password-store/extensions/import.bash \
      --prefix PATH : "${python3Packages.python.withPackages (_: propagatedBuildInputs)}/bin" \
      --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}" \
      --run "export PREFIX"
    cp -r ${src}/share $out/
  '';

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
