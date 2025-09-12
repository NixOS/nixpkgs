{
  lib,
  fetchurl,
  python3Packages,
  gnupg,
  pass,
}:

python3Packages.buildPythonApplication rec {
  pname = "pass-import";
  version = "3.5";
  format = "setuptools";

  src = fetchurl {
    url = "https://github.com/roddhjav/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-+wrff3OxPkAGu1Mn4Kl0KN4FmvIAb+MnaERcD5ScDNc=";
  };

  propagatedBuildInputs = with python3Packages; [
    cryptography
    defusedxml
    jsonpath-ng
    pyaml
    pykeepass
    python-magic # similar API to "file-magic", but already in nixpkgs.
    requests
    secretstorage
    zxcvbn
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
    cp import.bash $out/lib/password-store/extensions/import.bash
    wrapProgram $out/lib/password-store/extensions/import.bash \
      --prefix PATH : "${python3Packages.python.withPackages (_: propagatedBuildInputs)}/bin" \
      --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}" \
      --run "export PREFIX"
    cp -r share $out/
  '';

  postCheck = ''
    $out/bin/pimport --list-exporters --list-importers
  '';

  meta = with lib; {
    description = "Pass extension for importing data from existing password managers";
    mainProgram = "pimport";
    homepage = "https://github.com/roddhjav/pass-import";
    changelog = "https://github.com/roddhjav/pass-import/blob/v${version}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      lovek323
      fpletz
      tadfisher
    ];
    platforms = platforms.unix;
  };
}
