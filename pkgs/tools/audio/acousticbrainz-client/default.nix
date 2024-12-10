{
  lib,
  fetchFromGitHub,
  python3Packages,
  essentia-extractor,
}:

python3Packages.buildPythonApplication rec {
  pname = "acousticbrainz-client";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "MTG";
    repo = "acousticbrainz-client";
    rev = version;
    sha256 = "1g1nxh58939vysfxplrgdz366dlqnic05pkzbqh75m79brg4yrv1";
  };

  propagatedBuildInputs = [
    essentia-extractor
    python3Packages.requests
  ];

  postPatch = ''
    # The installer needs the streaming_extractor_music binary in the source directoy,
    # so we provide a symlink to it.
    ln -s ${essentia-extractor}/bin/streaming_extractor_music streaming_extractor_music
  '';

  postInstall = ''
    # The installer includes a copy of the streaming_extractor_music binary (not a symlink),
    # which we don't need, because the wrapper adds essentia-extractor/binary to PATH.
    rm $out/bin/streaming_extractor_music
  '';

  # Tests seem to be broken, but the tool works
  doCheck = false;

  pythonImportsCheck = [ "abz" ];

  meta = with lib; {
    description = "A client to upload data to an AcousticBrainz server";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/MTG/acousticbrainz-client";
    # essentia-extractor is only available for those platforms
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with maintainers; [ ];
    mainProgram = "abzsubmit";
  };
}
