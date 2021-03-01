{ stdenv, lib
, fetchFromGitHub
, python3
, installShellFiles
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "btrfs-heatmap";
  version = "8";

  src = fetchFromGitHub {
    owner = "knorrie";
    repo = "btrfs-heatmap";
    rev = "v${version}";
    sha256 = "035frvk3s7g18y81srssvm550nfq7jylr7w60nvixidxvrc0yrnh";
  };

  # man page is currently only in the debian branch
  # https://github.com/knorrie/btrfs-heatmap/issues/11
  msrc = fetchurl {
    url = "https://raw.githubusercontent.com/knorrie/btrfs-heatmap/45d844e12d7f5842ebb99e65d7b968a5e1a89066/debian/man/btrfs-heatmap.8";
    sha256 = "1md7xc426sc8lq4w29gjd6gv7vjqhcwrqqcr6z39kihvi04d5f6q";
  };

  buildInputs = [ python3 ];
  nativeBuildInputs = [ python3.pkgs.wrapPython installShellFiles ];

  outputs = [ "out" "man" ];

  installPhase = ''
    install -Dm 0755 heatmap.py $out/sbin/btrfs-heatmap
    installManPage ${msrc}

    buildPythonPath ${python3.pkgs.btrfs}
    patchPythonScript $out/sbin/btrfs-heatmap
  '';

  meta = with lib; {
    description = "Visualize the layout of a mounted btrfs";
    homepage = "https://github.com/knorrie/btrfs-heatmap";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.evils ];
  };
}
