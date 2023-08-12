{ lib, buildGoModule, fetchFromGitLab, python3 }:
buildGoModule rec {
  pname = "loccount";
  version = "2.15";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "loccount";
    rev = version;
    hash = "sha256-IRDwxz/InF4okyfAzbK0PzZz+HMUwv5LgRthUUy3rus=";
  };

  vendorHash = null;

  excludedPackages = "tests";

  nativeBuildInputs = [ python3 ];

  ldflags = [ "-s" "-w" ];

  preBuild = ''
    patchShebangs --build tablegen.py

    go generate
  '';

  meta = with lib; {
    description = "Re-implementation of sloccount in Go";
    longDescription = ''
      loccount is a re-implementation of David A. Wheeler's sloccount tool
      in Go.  It is faster and handles more different languages. Because
      it's one source file in Go, it is easier to maintain and extend than the
      multi-file, multi-language implementation of the original.

      The algorithms are largely unchanged and can be expected to produce
      identical numbers for languages supported by both tools.  Python is
      an exception; loccount corrects buggy counting of single-quote multiline
      literals in sloccount 2.26.
    '';
    homepage = "https://gitlab.com/esr/loccount";
    downloadPage = "https://gitlab.com/esr/loccount/tree/master";
    license = licenses.bsd2;
    maintainers = with maintainers; [ calvertvl ];
  };
}
