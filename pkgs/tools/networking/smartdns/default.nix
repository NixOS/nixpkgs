{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "smartdns";
  version = "33";

  src = fetchFromGitHub {
    owner = "pymumu";
    repo = pname;
    rev = "Release${version}";
    sha256 = "0cmzpm4y1yi96mg2cz2byqw6vl62dgnikldy08q43vi7jl3y0749";
  };

  buildInputs = [ openssl ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSTEMDSYSTEMUNITDIR=${placeholder "out"}/lib/systemd/system"
    "RUNSTATEDIR=/run"
  ];

  installFlags = [ "SYSCONFDIR=${placeholder "out"}/etc" ];

  meta = with stdenv.lib; {
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
