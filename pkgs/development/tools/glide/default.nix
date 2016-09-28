{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "glide-${version}";
  version = "0.12.2";
  
  goPackagePath = "github.com/Masterminds/glide";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Masterminds";
    repo = "glide";
    sha256 = "15cdrcslkiggd6sg5j40amflydpqz1s63f13mvlg309adfhsk4qz";
  };

  meta = with stdenv.lib; {
    homepage = https://glide.sh;
    description = "Package management for Go";
    license = licenses.mit;
    maintainers = [ maintainers.rushmorem ];
  };
}
