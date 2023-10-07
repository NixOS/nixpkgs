{ lib
, buildGoModule
, fetchgit
, unstableGitUpdater
}:

buildGoModule {
  pname = "bloat";
  version = "unstable-2023-10-02";

  src = fetchgit {
    url = "git://git.freesoftwareextremist.com/bloat";
    rev = "b83a00aa2cdabfc20c162379c885caac0110e167";
    hash = "sha256-E04XP3frzwaRNoc8HM96buODtGMs/nBJ7BDJD5VX40g=";
  };

  vendorHash = null;

  postInstall = ''
    mkdir -p $out/share/bloat
    cp -r templates $out/share/bloat/templates
    cp -r static $out/share/bloat/static
    sed \
      -e "s%=templates%=$out/share/bloat/templates%g" \
      -e "s%=static%=$out/share/bloat/static%g"       \
      < bloat.conf > $out/share/bloat/bloat.conf.example
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A web client for Pleroma and Mastodon";
    longDescription = ''
      A lightweight web client for Pleroma and Mastodon.
      Does not require JavaScript to display text, images, audio and videos.
    '';
    homepage = "https://bloat.freesoftwareextremist.com";
    downloadPage = "https://git.freesoftwareextremist.com/bloat/";
    license = licenses.cc0;
    maintainers = with maintainers; [ fgaz ];
  };
}
