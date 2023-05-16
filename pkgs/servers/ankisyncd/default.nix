<<<<<<< HEAD
{ lib, runCommand, fetchFromGitHub, rustPlatform, protobuf }:

let
  pname = "ankisyncd";
  version = "1.1.4";

  # anki-sync-server-rs expects anki sources in the 'anki' folder
  # of its own source tree, with a patch applied (mostly to make
  # some modules public): prepare our own 'src' manually
  src = runCommand "anki-sync-server-rs-src" {
    src = fetchFromGitHub {
      owner = "ankicommunity";
      repo = "anki-sync-server-rs";
      rev = version;
      hash = "sha256-iL4lJJAV4SrNeRX3s0ZpJ//lrwoKjLsltlX4d2wP6O0=";
    };
  } ''
    cp -r "$src/." "$out"
    chmod +w "$out"
    cp -r "${ankiSrc}" "$out/anki"
    chmod -R +w "$out/anki"
    patch -d "$out/anki" -Np1 < "$src/anki_patch/d9d36078f17a2b4b8b44fcb802eb274911ebabe7_anki_rslib.patch"
  '';

  # Note we do not use anki.src because the patch in ankisyncd's
  # sources expect a fixed version, so we pin it here.
  ankiSrc = fetchFromGitHub {
    owner = "ankitects";
    repo = "anki";
    rev = "2.1.60";
    hash = "sha256-hNrf6asxF7r7QK2XO150yiRjyHAYKN8OFCFYX0SAiwA=";
    fetchSubmodules = true;
  };
in rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "csv-1.1.6" = "sha256-w728ffOVkI+IfK6FbmkGhr0CjuyqgJnPB1kutMJIUYg=";
    };
  };

  nativeBuildInputs = [ protobuf ];

  meta = with lib; {
    description = "Standalone unofficial anki sync server";
    homepage = "https://github.com/ankicommunity/anki-sync-server-rs";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ martinetd ];
=======
{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ankisyncd";
  version = "2.2.0";
  src = fetchFromGitHub {
    owner = "ankicommunity";
    repo = "anki-sync-server";
    rev = version;
    hash = "sha256-RXrdJGJ+HMSpDGQBuVPPqsh3+uwAgE6f7ZJ0yFRMI8I=";
    fetchSubmodules = true;
  };
  format = "other";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python3.sitePackages}

    cp -r ankisyncd utils ankisyncd.conf $out/${python3.sitePackages}
    cp -r anki-bundled/anki $out/${python3.sitePackages}
    mkdir $out/share
    cp ankisyncctl.py $out/share/

    runHook postInstall
  '';

  fixupPhase = ''
    PYTHONPATH="$PYTHONPATH:$out/${python3.sitePackages}"

    makeWrapper "${python3.interpreter}" "$out/bin/ankisyncd" \
          --set PYTHONPATH $PYTHONPATH \
          --add-flags "-m ankisyncd"

    makeWrapper "${python3.interpreter}" "$out/bin/ankisyncctl" \
          --set PYTHONPATH $PYTHONPATH \
          --add-flags "$out/share/ankisyncctl.py"
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytest
    webtest
  ];

  buildInputs = [ ];

  propagatedBuildInputs = with python3.pkgs; [
    decorator
    requests
  ];

  checkPhase = ''
    # skip these tests, our files are too young:
    # tests/test_web_media.py::SyncAppFunctionalMediaTest::test_sync_mediaChanges ValueError: ZIP does not support timestamps before 1980
    pytest --ignore tests/test_web_media.py tests/
  '';

  meta = with lib; {
    description = "Self-hosted Anki sync server";
    maintainers = with maintainers; [ matt-snider ];
    homepage = "https://github.com/ankicommunity/anki-sync-server";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
