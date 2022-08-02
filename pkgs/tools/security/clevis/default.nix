{ lib
, stdenv
, fetchFromGitHub
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
