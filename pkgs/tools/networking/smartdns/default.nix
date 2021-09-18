{ lib, stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "smartdns";
  version = "35";

  src = fetchFromGitHub {
    owner = "pymumu";
    repo = pname;
    rev = "Release${version}";
    sha256 = "sha256-5822qe3mdn4wPO8fHW5AsgMA7xbJnMjZn9DbiMU3GX0=";
  };

  buildInputs = [ openssl ];

  # Force the systemd service file to be regenerated from it's template.  This
  # file is erroneously added in version 35 and it has already been deleted from
  # upstream's git repository.  So this "postPatch" phase can be deleted in next
  # release.
  postPatch = ''
    rm -f systemd/smartdns.service
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSTEMDSYSTEMUNITDIR=${placeholder "out"}/lib/systemd/system"
    "RUNSTATEDIR=/run"
  ];

  installFlags = [ "SYSCONFDIR=${placeholder "out"}/etc" ];

  meta = with lib; {
    description =
      "A local DNS server to obtain the fastest website IP for the best Internet experience";
    longDescription = ''
      SmartDNS is a local DNS server. SmartDNS accepts DNS query requests from local clients, obtains DNS query results from multiple upstream DNS servers, and returns the fastest access results to clients.
      Avoiding DNS pollution and improving network access speed, supports high-performance ad filtering.
      Unlike dnsmasq's all-servers, smartdns returns the fastest access resolution.
    '';
    homepage = "https://github.com/pymumu/smartdns";
    maintainers = [ maintainers.lexuge ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
