{ lib
, buildGoModule
, fetchgit
, unstableGitUpdater
}:

buildGoModule {
  pname = "bloat";
  version = "unstable-2022-05-10";

  src = fetchgit {
    url = "git://git.freesoftwareextremist.com/bloat";
    rev = "1661219ab6e3c12b29d676d57ce452feb81d0dd9";
    sha256 = "sha256-Vb0WTRYPv0+g0by+h09sDDMVCjRYF28PwbXJNkdX6NA=";
  };

  vendorSha256 = null;

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
