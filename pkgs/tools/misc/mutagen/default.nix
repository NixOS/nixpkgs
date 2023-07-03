{ stdenv, lib, buildGoModule, fetchFromGitHub, fetchzip }:

buildGoModule rec {
  pname = "mutagen";
  version = "0.16.6";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uBQzDZ2+rbk0up9nDeIFFJ5dMOo3Cq/acC+1jqo8Mqw=";
  };

  vendorSha256 = "sha256-iLLxGDdC4KHfbPFDRMmC7CV/HFpaBvx3c7FqQoNl/io=";

  agents = fetchzip {
    name = "mutagen-agents-${version}";
    # The package architecture does not matter since all packages contain identical mutagen-agents.tar.gz.
    url = "https://github.com/mutagen-io/mutagen/releases/download/v${version}/mutagen_linux_amd64_v${version}.tar.gz";
    stripRoot = false;
    postFetch = ''
      rm $out/mutagen # Keep only mutagen-agents.tar.gz.
    '';
    sha256 = "sha256-gAAO8+8ZbFTbf/QoWMtxcOi/+Zijh+QiQze+hP21fBE=";
  };

  doCheck = false;

  subPackages = [ "cmd/mutagen" "cmd/mutagen-agent" ];

  postInstall = ''
    install -d $out/libexec
    ln -s ${agents}/mutagen-agents.tar.gz $out/libexec/
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Make remote development work with your local tools";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen/releases/tag/v${version}";
    maintainers = [ maintainers.marsam ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
  };
}
