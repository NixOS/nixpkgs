{ stdenv, pkgs, lib, buildMix, fetchgit, ... }:

buildMix rec {
  name    = "plemora";
  version = "1.0.0";

  src = fetchgit {
    url = "https://git.pleroma.social/pleroma/pleroma/";
    rev = "v${version}";
    sha256 = "0bgdzbl7jd9lk7amnadpwy2fsqchz2vls3qymllgl917gn6a7r2j";
  };

  meta = with lib; {
    homepage        = "https://git.pleroma.social";
    maintainer      = [ maintainers.matthiasbeyer ];
    license         = stdenv.lib.licenses.agpl3;
    description     = "microblogging server software";
    longDescription = ''
      Pleroma is a microblogging server software that can federate (= exchange
      messages with) other servers that support the same federation standards
      (OStatus and ActivityPub). What that means is that you can host a server
      for yourself or your friends and stay in control of your online identity,
      but still exchange messages with people on larger servers. Pleroma will
      federate with all servers that implement either OStatus or ActivityPub,
      like Friendica, GNU Social, Hubzilla, Mastodon, Misskey, Peertube, and
      Pixelfed.

      Pleroma is written in Elixir, high-performance and can run on small
      devices like a Raspberry Pi.
    '';
  };
}
