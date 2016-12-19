{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper }:

buildGoPackage rec {
  name = "goa-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/goadesign/goa";
  subPackages = [ "goagen" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "goadesign";
    repo = "goa";
    sha256 = "13401jf907z3qh11h9clb3z0i0fshwkmhx11fq9z6vx01x8x2in1";
  };

  buildInputs = [ makeWrapper ];

  allowGoReference = true;

  outputs = [ "out" ];

  preInstall = ''
    export bin=$out
  '';

  postInstall = ''
    # goagen needs GOPATH to be set
    wrapProgram $out/bin/goagen \
      --prefix GOPATH ":" $out/share/go

    # and it needs access to all its dependancies
    mkdir -p $out/share/go
    cp -Rv $NIX_BUILD_TOP/go/{pkg,src} $out/share/go/
  '';

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://goa.design;
    description = "A framework for building microservices in Go using a unique design-first approach";
    license = licenses.mit;
    maintainers = [ maintainers.rushmorem ];
  };
}
