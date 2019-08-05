{ buildGoPackage
, fetchFromGitHub
, lib
, autossh
, makeWrapper
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

  goDeps = ./deps.nix;

  postInstall = ''
    mkdir -p $bin/bin $out/share/doc/${pname}
    cp -v ./go/src/github.com/StanfordSNR/${pname}/scripts/* $bin/bin/
    cp -vr ./go/src/github.com/StanfordSNR/${pname}/{AUTHORS,doc,LICENSE,README.md} $out/share/doc/guardian-agent
  '';

  postFixup = ''
		wrapProgram $bin/bin/sga-guard \
			--prefix PATH : "$bin/bin" \
			--prefix PATH : "${autossh}/bin"
  '';

  meta = with lib; {
    description = "Secure ssh-agent forwarding for Mosh and SSH";
    homepage = "https://github.com/StanfordSNR/guardian-agent";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmahut ];
    platforms = platforms.unix;
  };
}
