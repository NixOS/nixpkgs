{ stdenv, fetchFromGitHub, makeWrapper, python3Packages }:

stdenv.mkDerivation rec {
  pname = "theHarvester";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "laramies";
    repo = pname;
    rev = version;
    sha256 = "0f33a7sfb5ih21yp1wspb03fxsls1m14yizgrw0srfirm2a6aa0c";
  };

  nativeBuildInputs = [ makeWrapper ];

  # add dependencies
  propagatedBuildInputs = with python3Packages; [ requests beautifulsoup4 plotly ];

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
    homepage = "https://github.com/laramies/theHarvester";
    platforms = platforms.all;
    maintainers = with maintainers; [ treemo ];
    license = licenses.gpl2;
  };
}
