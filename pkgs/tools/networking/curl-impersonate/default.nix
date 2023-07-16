#TODO: It should be possible to build this from source, but it's currently a lot faster to just package the binaries.
{ lib, stdenv, fetchzip, zlib, autoPatchelfHook }:
let
  platformNames = {
    "x86_64-linux" = "x86_64-linux-gnu";
    "aarch64-linux" = "aarch64-linux-gnu";
    "x86_64-darwin" = "x86_64-macos";
  };
  hashes = {
    "x86_64-linux" = "sha256-HrP+bwY9LCL6v0l/ZTjAIRmliCV4cMjr/E5ANPSEnMo=";
    "aarch64-linux" = "sha256-g44HjTceaHsJpS/tYi5VEwShYa9Z8xuXKOd2c1urBPw=";
    "x86_64-darwin" = "sha256-9c9lbNTMnlw2OMb+EgeK4beKey/nAxTGKccWdhC3v34=";
  };
in
stdenv.mkDerivation rec {
  pname = "curl-impersonate-bin";
  version = "0.5.4";

  src = fetchzip {
    url = "https://github.com/lwthiker/curl-impersonate/releases/download/v${version}/curl-impersonate-v${version}.${platformNames.${stdenv.system}}.tar.gz";
    hash = hashes.${stdenv.system};
    stripRoot = false;
  };

  nativeBuildInputs = [ autoPatchelfHook zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin
  '';

  installCheckPhase = ''
    $( ls "$out/bin"/curl_chrome* | head -n 1 ) --version
  '';
  doInstallCheck = true;

  meta = with lib; {
    description = "curl-impersonate: A special build of curl that can impersonate Chrome & Firefox ";
    homepage = "https://github.com/lwthiker/curl-impersonate";
    license = with licenses; [ curl mit ];
    maintainers = with maintainers; [ deliciouslytyped ];
    platforms = lib.attrNames platformNames;
  };
}
