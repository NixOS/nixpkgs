{ stdenv, lib, buildGoModule, fetchFromGitHub, fetchzip }:

buildGoModule rec {
  pname = "mutagen";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OoRXf0QboRQkZE4zcwlGFyoToGOy1bbgGSo17BQLqCE=";
  };

  vendorSha256 = "sha256-dkPpz0SZEAMPR7mq11kDHGCgeIpnXj2lRnJo1Ws32Cc=";

  agents = fetchzip {
    name = "mutagen-agents-${version}";
    # The package architecture does not matter since all packages contain identical mutagen-agents.tar.gz.
    url = "https://github.com/mutagen-io/mutagen/releases/download/v${version}/mutagen_linux_amd64_v${version}.tar.gz";
    stripRoot = false;
    postFetch = ''
      rm $out/mutagen # Keep only mutagen-agents.tar.gz.
    '';
    sha256 = "sha256-AlAo55/ewTE04WfS0beVonGA97AmpR1pAw/QxKAYjv8=";
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
