{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nebula";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "slackhq";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xrki9w83b4b3l5adq1rxz374f124wf388sdyvy7ngc3b04k7qlb";
  };

  vendorSha256 = "094mn1r69c40w7k3lsggjh0dpws9l0j7mgiyjy1lpblkvkyk2azm";

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
