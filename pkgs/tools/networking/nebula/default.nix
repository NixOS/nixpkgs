{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nebula";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "slackhq";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+RferzOPlx7UuqpckQBY/RDO9gptknhuan+Es0Vf/yM=";
  };

  vendorHash = "sha256-4BnFvA0dxsEK7ictDUZ6nol6PtM54kk9dwKPTQbRUR0=";

  subPackages = [ "cmd/nebula" "cmd/nebula-cert" ];

  ldflags = [ "-X main.Build=${version}" ];

  passthru.tests = {
    inherit (nixosTests) nebula;
  };

  meta = with lib; {
    description = "Overlay networking tool with a focus on performance, simplicity and security";
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
    changelog = "https://github.com/slackhq/nebula/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne numinit ];
  };
}
