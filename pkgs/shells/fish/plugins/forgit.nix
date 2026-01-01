{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "forgit";
<<<<<<< HEAD
  version = "26.01.0";
=======
  version = "25.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-3PjKFARsN3BE5c3/JonNj+LpKBPT1N3hc1bK6NdWDTQ=";
=======
    hash = "sha256-MG60GzRG0NFQsGXBXBedSweucxo88S/NACXTme7ixRM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postInstall = ''
    cp -r bin $out/share/fish/vendor_conf.d/
  '';

<<<<<<< HEAD
  meta = {
    description = "Utility tool powered by fzf for using git interactively";
    homepage = "https://github.com/wfxr/forgit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
=======
  meta = with lib; {
    description = "Utility tool powered by fzf for using git interactively";
    homepage = "https://github.com/wfxr/forgit";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
