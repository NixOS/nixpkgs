{ buildGoPackage
, fetchFromGitHub
, lib
, autossh
, makeWrapper
, stdenv
}:

buildGoPackage rec {
  pname = "guardian-agent";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "StanfordSNR";
    repo = pname;
    rev = "v${version}-beta";
    sha256 = "05269y944hcabn6dqa66387rdhx81vcqcyjv6m1hdbz5ba8j7mqn";
  };

  nativeBuildInputs = [ makeWrapper ];

  goPackagePath = "github.com/StanfordSNR/guardian-agent";

  deleteVendor = true;
  goDeps = ./deps.nix;

  postInstall = ''
    mkdir -p $out/bin $out/share/doc/${pname}
    cp -v ./go/src/github.com/StanfordSNR/${pname}/scripts/* $out/bin/
    cp -vr ./go/src/github.com/StanfordSNR/${pname}/{AUTHORS,doc,LICENSE,README.md} $out/share/doc/guardian-agent
  '';

  postFixup = ''
    wrapProgram $out/bin/sga-guard \
      --prefix PATH : "$out/bin" \
      --prefix PATH : "${autossh}/bin"
  '';

  meta = with lib; {
    description = "Secure ssh-agent forwarding for Mosh and SSH";
    homepage = "https://github.com/StanfordSNR/guardian-agent";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmahut ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # x/sys/unix needs an update, but software is unmaintained
  };
}
