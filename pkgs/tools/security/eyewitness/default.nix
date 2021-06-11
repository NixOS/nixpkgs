{ stdenv
, fetchFromGitHub
, firefox
, geckodriver
, xorg
, python37
, python37Packages
}:

stdenv.mkDerivation rec {
  pname = "eyewitness";
  version = "v20201021.1";

  src = fetchFromGitHub {
    owner = "FortyNorthSecurity";
    repo = "EyeWitness";
    rev = version;
    sha256 = "16ayiklgf9d1sq8phsfpg1kjs40y4dpwzgwgx8vy2n32ckqv8f6i";
  };

  # These _are_ runtime, not buildtime dependencies. EyeWitness functions by
  # executing firefox in Xvfb so have a somewhat 'heavy' dependency tree.
  #
  # After EyeWitness finishes processing, firefox and Xvfb are terminated.
  propagatedBuildInputs = [
    firefox
    geckodriver
    xorg.xorgserver
    python37
    python37Packages.pip
    python37Packages.netaddr
    python37Packages.selenium
    python37Packages.fuzzywuzzy
    python37Packages.virtual-display
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    mv Python bin
    cp -r bin $out/bin

    runHook postInstall
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Headless process to take screenshots of websites, capture header info, identify default credentials if known";
    homepage = "https://github.com/FortyNorthSecurity/EyeWitness";
    maintainers = with maintainers; [ redvers ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
