{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mattermost-${version}";
  version = "3.6.2";

  src = fetchurl {
    url = "https://releases.mattermost.com/${version}/mattermost-team-${version}-linux-amd64.tar.gz";
    sha256 = "1wf8xvy8njmhym45dwag6mdwhfgzg5xccvhyv7c68rz5h57vfgsb";
  };

  installPhase = ''
    mkdir -p $out
    mv * $out/
    ln -s ./platform $out/bin/mattermost-platform
  '';

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/platform
  '';

  meta = with stdenv.lib; {
    description = "Open-Source, self-hosted Slack-alternative";
    homepage = "https://www.mattermost.org";
    license = with licenses; [ agpl3 asl20 ];
    maintainers = with maintainers; [ fpletz ];
    platforms = [ "x86_64-linux" ];
  };
}
