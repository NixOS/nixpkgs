{ stdenv, lib, go, gox, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "packer-0.8.6";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go gox ];

  installPhase = ''
    export GOPATH=$src
    XC_ARCH=$(go env GOARCH)
    XC_OS=$(go env GOOS)

    mkdir -p $out/bin

    cd $src/src/github.com/mitchellh/packer
    gox \
        -os="''${XC_OS}" \
        -arch="''${XC_ARCH}" \
        -output "$out/bin/packer-{{.Dir}}" \
        ./...
    mv $out/bin/packer{*packer*,}
  '';

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "http://www.packer.io";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = platforms.unix;
  };
}
