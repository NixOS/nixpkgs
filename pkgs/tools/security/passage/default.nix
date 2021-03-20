{ lib, fetchFromSourcehut, rustPlatform, installShellFiles, asciidoctor, python3, xorg, passAlias ? false }:

rustPlatform.buildRustPackage rec {
  pname = "passage";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~gpanders";
    repo = "passage";
    rev = "9bddfe8e03b39ceccfa736e88924d3b4cb59748f";
    sha256 = "1vdl02aqxb66nniwgsafq45b1xb53jqsprs7n0liry4gh639rc81";
  };

  cargoSha256 = "06clfavpxc7a11jxml0vkw8x7lya5kipv8xyi59f8fqsksj79k8m";

  nativeBuildInputs = [ asciidoctor python3 installShellFiles ];
  buildInputs = [ xorg.libxcb ];

  postBuild = ''
    asciidoctor doc/passage.1.txt --backend manpage --doctype manpage -o passage.1
  '';

  postInstall = ''
    installManPage passage.1
  '' + lib.optionalString passAlias ''
    ln -s $out/bin/passage $out/bin/pass
  '';

  meta = with lib; {
    description = "passage is a password store utilizing the age encryption library";
    homepage = "https://sr.ht/~gpanders/passage";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rassmike ];
  };
}
