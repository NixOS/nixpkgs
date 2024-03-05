{ lib
, stdenv
, asciidoc
, coreutils
, cryptsetup
, curl
, fetchFromGitHub
, gnugrep
, gnused
, jansson
, jose
, libpwquality
, luksmeta
, makeWrapper
, meson
, ninja
, pkg-config
, tpm2-tools
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "clevis";
  version = "19";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3J3ti/jRiv+p3eVvJD7u0ko28rPd8Gte0mCJaVaqyOs=";
  };

  patches = [
    # Replaces the clevis-decrypt 300s timeout to a 10s timeout
    # https://github.com/latchset/clevis/issues/289
    ./tang-timeout.patch
  ];

  postPatch = ''
    for f in $(find src/ -type f); do
      grep -q "/bin/cat" "$f" && substituteInPlace "$f" \
        --replace '/bin/cat' '${coreutils}/bin/cat' || true
    done
  '';

  postInstall = ''
    # We wrap the main clevis binary entrypoint but not the sub-binaries.
    wrapProgram $out/bin/clevis \
      --prefix PATH ':' "${lib.makeBinPath [tpm2-tools jose cryptsetup libpwquality luksmeta gnugrep gnused coreutils]}:${placeholder "out"}/bin"
  '';

  nativeBuildInputs = [
    asciidoc
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cryptsetup
    curl
    jansson
    jose
    libpwquality
    luksmeta
    tpm2-tools
  ];

  outputs = [
    "out"
    "man"
  ];

  passthru.tests = {
    inherit (nixosTests.installer) clevisBcachefs clevisBcachefsFallback clevisLuks clevisLuksFallback clevisZfs clevisZfsFallback;
    clevisLuksSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisLuks;
    clevisLuksFallbackSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisLuksFallback;
    clevisZfsSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisZfs;
    clevisZfsFallbackSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisZfsFallback;
  };

  meta = with lib; {
    description = "Automated Encryption Framework";
    homepage = "https://github.com/latchset/clevis";
    changelog = "https://github.com/latchset/clevis/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
