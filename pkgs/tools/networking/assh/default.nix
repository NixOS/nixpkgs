{ stdenv, lib, buildGoPackage, fetchFromGitHub, openssh, makeWrapper }:

buildGoPackage rec {
  name = "assh-${version}";
  version = "2.7.0";

  goPackagePath = "github.com/moul/advanced-ssh-config";
  subPackages = [ "cmd/assh" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$bin/bin/assh" \
      --prefix PATH : ${openssh}/bin
  '';

  src = fetchFromGitHub {
    repo = "advanced-ssh-config";
    owner = "moul";
    rev = "v${version}";
    sha256 = "0jfpcr8990lb7kacadbishdkz5l8spw24ksdlb79x34sdbbp3fm6";
  };

  meta = with stdenv.lib; {
    description = "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts";
    homepage = https://github.com/moul/advanced-ssh-config;
    license = licenses.mit;
    maintainers = with maintainers; [ zzamboni ];
    platforms = with platforms; linux ++ darwin;
  };
}
