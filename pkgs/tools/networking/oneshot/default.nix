{ lib, fetchFromGitHub, buildGoModule, updateGolangSysHook }:

buildGoModule rec {
  pname = "oneshot";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "raphaelreyna";
    repo = "oneshot";
    rev = "v${version}";
    sha256 = "sha256-5NCGKgmioTOHGJEWMIEsZlA+072XXL9L8KbEH6+caHc=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-qExooybaSPeLppVA9mxNNTN52aVsXHV/OgU7eZI1CDo=";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "A first-come-first-serve single-fire HTTP server";
    homepage = "https://github.com/raphaelreyna/oneshot";
    license = licenses.mit;
    maintainers = with maintainers; [ milibopp ];
  };
}
