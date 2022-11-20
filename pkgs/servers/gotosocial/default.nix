{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gotosocial";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "superseriousbusiness";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-85UmO2ncPMSVbwmeYFWnZ39qZSfsQ+pFovmzhzdnQYo=";
  };

  vendorHash = null;

  meta = with lib; {
    homepage = "https://docs.gotosocial.org/";
    description = "Fast, fun, ActivityPub server, powered by Go";
    longDescription = ''
      ActivityPub social network server, written in Golang.
      You can keep in touch with your friends, post, read, and
      share images and articles. All without being tracked or
      advertised to! A light-weight alternative to Mastodon
      and Pleroma, with support for clients!
    '';
    maintainers = with maintainers; [ pbsds ];
    license = licenses.agpl3Only;
  };
}
