{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fission";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = version;
    sha256 = "sha256-ohVQ5fQ2VCUcS3fSKp2l8/nwXeAesxawFCjKu5iqF+s=";
  };

  vendorSha256 = "sha256-1ujJuhK7pm/A1Dd+Wm9dtc65mx9pwLBWMWwEJnbja8s=";

  buildFlagsArray = "-ldflags=-s -w -X info.Version=${version}";

  subPackages = [ "cmd/fission-cli" ];

  postInstall = ''
    ln -s $out/bin/fission-cli $out/bin/fission
  '';

  meta = with lib; {
    description = "The cli used by end user to interact Fission";
    homepage = "https://fission.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ neverbehave ];
  };
}
