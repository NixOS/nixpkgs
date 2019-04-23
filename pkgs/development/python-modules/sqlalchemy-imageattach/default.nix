{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
, Wand
, webob
, sqlalchemy
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  pname = "SQLAlchemy-ImageAttach";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    repo = "sqlalchemy-imageattach";
    owner = "dahlia";
    rev = "${version}";
    sha256 = "0ba97pn5dh00qvxyjbr0mr3pilxqw5kb3a6jd4wwbsfcv6nngqig";
  };

  checkInputs = [ pytest Wand.imagemagick webob ];
  propagatedBuildInputs = [ sqlalchemy Wand ];

  checkPhase = ''
    cd tests
    export MAGICK_HOME="${pkgs.imagemagick.dev}"
    export PYTHONPATH=$PYTHONPATH:../
    py.test
    cd ..
  '';

  doCheck = !isPyPy;  # failures due to sqla version mismatch

  meta = with stdenv.lib; {
    homepage = https://github.com/dahlia/sqlalchemy-imageattach;
    description = "SQLAlchemy extension for attaching images to entity objects";
    license = licenses.mit;
  };

}
