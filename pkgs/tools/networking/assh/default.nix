{ stdenv, lib, buildGoPackage, fetchFromGitHub, openssh, makeWrapper }:

buildGoPackage rec {
  name = "assh-${version}";
  version = "2.6.0";

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
    sha256 = "1vv98dz5822k51xklnmky0lwfjw8nc6ryvn8lmv9n63ppwh9s2s6";
  };

  meta = with stdenv.lib; {
    description = "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts";
    homepage = https://github.com/moul/advanced-ssh-config;
    license = licenses.mit;
    maintainers = with maintainers; [ zzamboni ];
    platforms = with platforms; linux ++ darwin;
  };
}
