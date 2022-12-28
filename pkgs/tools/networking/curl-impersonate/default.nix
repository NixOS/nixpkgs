#TODO: It should be possible to build this from source, but it's currently a lot faster to just package the binaries.
{ lib, stdenv, fetchzip, zlib, autoPatchelfHook }:
stdenv.mkDerivation rec {
  pname = "curl-impersonate-bin";
  version = "v0.5.3";

  src = fetchzip {
    url = "https://github.com/lwthiker/curl-impersonate/releases/download/${version}/curl-impersonate-${version}.x86_64-linux-gnu.tar.gz";
    sha256 = "sha256-+cH1swAIadIrWG9anzf0dcW6qyBjcKsUHFWdv75F49g=";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoPatchelfHook zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin
  '';

  meta = with lib; {
    description = "curl-impersonate: A special build of curl that can impersonate Chrome & Firefox ";
    homepage = "https://github.com/lwthiker/curl-impersonate";
    license = with licenses; [ curl mit ];
    maintainers = with maintainers; [ deliciouslytyped ];
    platforms = platforms.linux; #TODO I'm unsure about the restrictions here, feel free to expand the platforms it if it works elsewhere.
  };
}
