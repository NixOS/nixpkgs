{ stdenv, lib, go, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "consul-template-${version}";
  version = "0.7.0";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    GOPATH=$src go build -v -o consul-template github.com/hashicorp/consul-template
  '';

  installPhase = ''
    # Fix references to go-deps in the binary
    hash=$(echo $src | sed 's,.*/\([^/-]*\).*,\1,g')
    xs=$(printf 'x%.0s' $(seq 2 $(echo $hash | wc -c)))
    sed -i "s,$hash,$xs,g" consul-template

    mkdir -p $out/bin
    cp consul-template $out/bin
  '';

  meta = with lib; {
    description = "Generic template rendering and notifications with Consul";
    homepage = https://github.com/hashicorp/consul-template;
    license = licenses.mpl20;
    maintainers = with maintainers; [ puffnfresh wkennington ];
    platforms = platforms.unix;
  };
}
