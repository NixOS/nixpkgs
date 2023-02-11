{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, meson
, ninja
, pkg-config
, asciidoc
, makeWrapper
, jansson
, jose
, cryptsetup
, curl
, libpwquality
, luksmeta
, coreutils
, tpm2-tools
, gnugrep
, gnused
}:

stdenv.mkDerivation rec {
  pname = "clevis";
  version = "18";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m1UhyjD5ydSgCTBu6sECLlxFx0rnQxFnBA7frbdUqU8=";
  };

  patches = [
    # sss: use BN_set_word(x, 0) instead of BN_zero(), fixes build issue with different versions of openssl
    (fetchurl {
      url = "https://github.com/latchset/clevis/commit/ee1dfedb9baca107e66a0fec76693c9d479dcfd9.patch";
      sha256 = "sha256-GeklrWWlAMALDLdnn6+0Bi0l+bXrIbYkgIyI94WEybM=";
    })
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

  nativeBuildInputs = [ meson ninja pkg-config asciidoc makeWrapper ];
  buildInputs = [ jansson jose cryptsetup curl libpwquality luksmeta tpm2-tools ];

  outputs = [ "out" "man" ];

  meta = {
    description = "Automated Encryption Framework";
    homepage = "https://github.com/latchset/clevis";
    maintainers = with lib.maintainers; [ ];
    license = lib.licenses.gpl3Plus;
  };
}
