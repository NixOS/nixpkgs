{ stdenv, makeWrapper, python2Packages, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "theHarvester";
  version = "2.7.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "laramies";
    repo = "${pname}";
    rev = "25553762d2d93a39083593adb08a34d5f5142c60";
    sha256 = "0gnm598y6paz0knwvdv1cx0w6ngdbbpzkdark3q5vs66yajv24w4";
  };

  nativeBuildInputs = [ makeWrapper ];

  # add dependencies
  propagatedBuildInputs = [ python2Packages.requests ];

  installPhase = ''
    # create dirs
    mkdir -p $out/share/${pname} $out/bin

    # move project code
    mv * $out/share/${pname}/

    # make project runnable
    chmod +x $out/share/${pname}/theHarvester.py
    ln -s $out/share/${pname}/theHarvester.py $out/bin

    wrapProgram "$out/bin/theHarvester.py" --prefix PYTHONPATH : $out/share/${pname}:$PYTHONPATH
  '';

  meta = with stdenv.lib; {
    description = "Gather E-mails, subdomains and names from different public sources";
    homepage = https://github.com/laramies/theHarvester;
    platforms = platforms.all;
    maintainers = with maintainers; [ treemo ];
    license = licenses.gpl2;
  };
}
