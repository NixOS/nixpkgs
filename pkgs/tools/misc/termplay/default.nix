{ rustPlatform, fetchFromGitHub, lib, makeWrapper, gst_all_1, libsixel }:
rustPlatform.buildRustPackage rec {
  pname = "termplay";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "jD91mZM2";
    repo = "termplay";
    rev = version;

    sha256 = "0qgx9xmi8n3sq5n5m6gai777sllw9hyki2kwsj2k4h1ykibzq9r0";
  };

  cargoBuildFlags = ["--features" "bin"];
  cargoSha256 = "06vf2lhdsp7vsln8007zd1xcswn5akk9gnhh7582x1siiijksmn7";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
    libsixel
  ];

  postInstall = ''
    wrapProgram $out/bin/termplay --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  meta = with lib; {
    description = "Play an image/video in your terminal";
    homepage = https://jd91mzm2.github.io/termplay/;
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
  };
}
