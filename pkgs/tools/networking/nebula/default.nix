{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nebula";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "slackhq";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nwagk3q2gkirqrk27fisad2c2p2y1lsvz5phax9v5h51p1y79ia";
  };

  modSha256 = "1sy5mnwn9fxjf3y41lm8gsggid2c0y08iw88m9ng8psaf4qid8ij";

  subPackages = [ "cmd/nebula" "cmd/nebula-cert" ];

  buildFlagsArray = [ "-ldflags='-X main.Build=${version}'" ];

  meta = with lib; {
    description = "A scalable overlay networking tool with a focus on performance, simplicity and security";
    longDescription = ''
      Nebula is a scalable overlay networking tool with a focus on performance,
      simplicity and security. It lets you seamlessly connect computers
      anywhere in the world. Nebula is portable, and runs on Linux, OSX, and
      Windows. (Also: keep this quiet, but we have an early prototype running
      on iOS). It can be used to connect a small number of computers, but is
      also able to connect tens of thousands of computers.

      Nebula incorporates a number of existing concepts like encryption,
      security groups, certificates, and tunneling, and each of those
      individual pieces existed before Nebula in various forms. What makes
      Nebula different to existing offerings is that it brings all of these
      ideas together, resulting in a sum that is greater than its individual
      parts.
    '';
    homepage = "https://github.com/slackhq/nebula";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };

}
