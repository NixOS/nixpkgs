{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.23.7";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sfl2nyzspqllbklc9wf62wqxs0k3ac7vzqz8kl5h9ch654g542a";
  };

  modSha256 = "0r5ybr4gpcdsldk12b0d4xiih6ckwnqkfwy89c97prv24v14zysv";

  meta = with stdenv.lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun ];
    platforms = platforms.all;
  };
}
